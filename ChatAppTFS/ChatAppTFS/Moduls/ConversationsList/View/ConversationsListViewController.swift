//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class ConversationsListViewController: UIViewController, ConversationsListViewProtocol {
	
	// MARK: - Properties
	
	var presenter: ConversationsListPresenterProtocol?
	let tableView = UITableView(frame: .zero, style: .plain)
	let leftBarButton = UIButton()
	let rightBarButton = UIButton()
	
	private let barButtonSize = Constants.ConversationListScreen.barButtonSize
	
	convenience init(presenter: ConversationsListPresenterProtocol) {
		self.init()
		self.presenter = presenter
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Channels"
		presenter?.viewDidLoad()
		addTargets()
		setUpTableView()
		setUpRightBarItem()
		setUpLeftBarItem()
		delegating()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		rightBarButton.round()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.viewWillAppear()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.viewWillDisappear()
	}
	
	// MARK: - Private
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = presenter?.dataSource
	}
	
	private func setUpLeftBarItem() {
		let image = UIImage(named: "themes")
		leftBarButton.setImage(image, for: .normal)
		leftBarButton.clipsToBounds = true
		leftBarButton.layer.masksToBounds = true
		leftBarButton.backgroundColor = .clear
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
	}

	private func setUpRightBarItem() {
		let resizeImage = UIImage.textImage(text: "FN")?.resize(width: barButtonSize, height: barButtonSize)
		rightBarButton.setImage(resizeImage, for: .normal)
		rightBarButton.clipsToBounds = true
		rightBarButton.layer.masksToBounds = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
		presenter?.getUserName { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let text):
				guard let image = UIImage.textImage(text: text.getCapitalLetters()) else {
					return
				}
				self.rightBarButton.setImage(image.resize(width: self.barButtonSize, height: self.barButtonSize), for: .normal)
			case .failure: break
			}
		}
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
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView]|",
			metrics: nil,
			views: ["tableView": tableView]))
	}
	
	private func addTargets() {
		leftBarButton.addTarget(self, action: #selector(didTapLeftBarButton), for: .touchUpInside)
		rightBarButton.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
	}
	
	@objc private func didTapLeftBarButton() {
		presenter?.leftBarButtonTapped()
	}
	
	@objc private func didTapRightBarButton() {
		presenter?.rightBarButtonTapped()
	}
	
	func presentCreateChannelAlert() {
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
			self?.presenter?.createNewChannel(with: channelName)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	func insert(at newIndexPath: IndexPath) {
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
	
	func delete(at indexPath: IndexPath) {
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	func update(at indexPath: IndexPath) {
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	func move(at indexPath: IndexPath, to newIndexPath: IndexPath) {
		tableView.moveRow(at: indexPath, to: newIndexPath)
	}
	
	func beginUpdates() {
		tableView.beginUpdates()
	}
	
	func endUpdates() {
		tableView.endUpdates()
	}
	
	func reload() {
		tableView.reloadData()
	}
	
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return ConversationsListTableViewCell.preferredHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.didTapAt(indexPath: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return ConversationsListTableHeaderView.preferredHeight
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		 guard let headerView = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: ConversationsListTableHeaderView.identifier) as? ConversationsListTableHeaderView else {
			return UIView()
		}
		headerView.addingChannel = { [weak self] in
			self?.presentCreateChannelAlert()
		}
		return headerView
	}
}
