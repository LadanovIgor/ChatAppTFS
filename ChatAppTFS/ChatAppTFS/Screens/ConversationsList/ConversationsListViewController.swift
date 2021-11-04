//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class ConversationsListViewController: UIViewController {
	
	// MARK: - Properties
	
	private lazy var db = Firestore.firestore()
	private lazy var reference = db.collection("channels")
	
	var channels = [Channel]()
//	var channel: Channel?
	
	private var tableView = UITableView(frame: .zero, style: .plain)
	
	private let barButtonSize = Constants.ConversationListScreen.barButtonSize

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Channels"
		setUpTableView()
		setUpRightBarItem()
		setUpLeftBarItem()
		addFirestoreListener()
		loadFromDatabase()
	}
	
	// MARK: - Private
	
	private func setUpLeftBarItem() {
		let button = UIButton()
		let resizeImage = UIImage(named: "themes")
		button.setImage(resizeImage, for: .normal)
		button.clipsToBounds = true
		button.layer.masksToBounds = true
		button.backgroundColor = .clear
		button.addTarget(self, action: #selector(didTapLeftBarButton), for: .touchUpInside)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
	}

	private func setUpRightBarItem() {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: barButtonSize, height: barButtonSize))
		let resizeImage = UIImage.textImage(text: "FN")?.resize(width: barButtonSize, height: barButtonSize)
		button.setImage(resizeImage, for: .normal)
		button.clipsToBounds = true
		button.layer.masksToBounds = true
		button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
		button.round()
		LocalStorageManager.shared.getValue(for: Constants.LocalStorage.nameKey) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let data):
				guard let text = String(data: data, encoding: .utf8),
					  let image = UIImage.textImage(text: text.getCapitalLetters()) else { return }
				button.setImage(image.resize(width: self.barButtonSize, height: self.barButtonSize), for: .normal)
			case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}
	
	@objc private func didTapLeftBarButton() {
		presentThemeVC()
	}
	
	@objc private func didTapRightBarButton() { 
		present(UserProfileViewController(), animated: true)
	}

	private func presentThemeVC() {
		let vc = ThemeViewController()
		vc.themeSelected = {[weak self] theme in
			self?.changeTheme(for: theme)
		}
		present(vc, animated: true)
	}
	
	private func setUpTableView() {
		tableView.showsVerticalScrollIndicator = false
		tableView.separatorStyle = .none
		tableView.register(
			ConversationsListTableViewCell.nib,
			forCellReuseIdentifier: ConversationsListTableViewCell.name)
		tableView.register(
			ConversationsListTableHeaderView.self,
			forHeaderFooterViewReuseIdentifier: ConversationsListTableHeaderView.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView]|",
			metrics: nil,
			views: ["tableView": tableView]))
	}
	
	private func logThemeChanging(selectedTheme: Theme) {
		print("Выбрана тема: \(selectedTheme.description() ?? "")")
		let color = selectedTheme.color()
		UINavigationBar.appearance().barTintColor = color
		UINavigationBar.appearance().backgroundColor = color
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
		UITableView.appearance().backgroundColor = color
		UIView.appearance(whenContainedInInstancesOf: [UITableView.self]).backgroundColor = color
		UIVisualEffectView.appearance().backgroundColor = color
		UILabel.appearance().textColor = .black
		UIApplication.shared.windows.reload()
	}
	
	private func changeTheme(for theme: ThemeProtocol) {
		theme.apply(for: UIApplication.shared)
		let themeName = String(describing: type(of: theme).self)
		guard let themeNameData = themeName.data(using: .utf8) else {
			return
		}
		let dict = [Constants.LocalStorage.themeKey: themeNameData]
		LocalStorageManager.shared.saveLocally(dict) { _ in
			
		}
	}
	
	private func addFirestoreListener() {
		reference.addSnapshotListener { [weak self] snapshot, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let documents = snapshot?.documents else {
				print(CustomFirebaseError.snapshotNone.localizedDescription)
				return
			}
			self?.getChannelsFrom(documents: documents)
		}
	}
	
	private func getChannelsFrom(documents: [QueryDocumentSnapshot]) {
		documents.forEach { channels.append(Channel(with: $0)) }
		channels.sort { ($0.lastActivity ?? Date()) > ($1.lastActivity ?? Date()) }
		saveToDatabase()
		tableView.reloadData()
	}
	
	private func loadFromDatabase() {
		DatabaseManager.shared.fetchChannels {result in
			switch result {
			case .success: break
//					channels.forEach { print($0.name) }
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	private func presentNewChannelAlert() {
		var textField = UITextField()
		let alert = UIAlertController(title: "New channel", message: nil, preferredStyle: .alert)
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Channel name"
			textField = alertTextField
		}
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
			guard let channelName = textField.text, !channelName.isEmpty else {
				return
			}
			self?.createNewChannelWith(name: channelName)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	private func createNewChannelWith(name: String) {
		reference.addDocument(data: ["name": name])
		tableView.reloadData()
	}
	
	private func saveToDatabase() {
		DatabaseManager.shared.save(channels: channels) { result in
			switch result {
			case .success: break
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return ConversationsListTableViewCell.preferredHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let vc = ConversationViewController(channel: channels[indexPath.row])
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return UITableView.automaticDimension
	}
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return channels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationsListTableViewCell.name,
			for: indexPath) as? ConversationsListTableViewCell else {
				return UITableViewCell()
			}
		cell.configure(with: .init(with: channels[indexPath.row]))
		cell.layoutIfNeeded()
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		 guard let headerView = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: ConversationsListTableHeaderView.identifier) as? ConversationsListTableHeaderView else {
			return UIView()
		}
		headerView.addingChannel = { [weak self] in
			self?.presentNewChannelAlert()
		}
		return headerView
	}
}

extension ConversationsListViewController: ThemesViewControllerDelegate {
	func themesViewController(_ controller: UIViewController, didSelect selectedTheme: Theme) {
		logThemeChanging(selectedTheme: selectedTheme)
	}
}
