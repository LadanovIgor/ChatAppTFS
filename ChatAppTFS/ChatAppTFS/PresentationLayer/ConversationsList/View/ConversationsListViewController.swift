//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
	
	// MARK: - Properties
	
	private var presenter: ConversationsListPresenterProtocol?
	private let tableView = UITableView(frame: .zero, style: .plain)
	private let leftBarButton = UIButton()
	private let rightBarButton = UIButton()
	private let barButtonSize = Constants.ConversationListScreen.barButtonSize
	
	lazy var animationController: AnimationController = {
		let startingPoint = rightBarButton.convert(rightBarButton.center, to: view)
		let animationController = AnimationController(duration: 1.0, startingPoint: startingPoint)
		return animationController
	}()
		
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Channels"
		setUpRightBarItem()
		presenter?.viewDidLoad()
		addTargets()
		setUpTableView()
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
	
	// MARK: - Init
	
	convenience init(presenter: ConversationsListPresenterProtocol) {
		self.init()
		self.presenter = presenter
	}
	
	// MARK: - Private
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = presenter?.dataSource
		transitioningDelegate = self
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
		rightBarButton.accessibilityIdentifier = "profile"
		rightBarButton.setImage(resizeImage, for: .normal)
		rightBarButton.clipsToBounds = true
		rightBarButton.layer.masksToBounds = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
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
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

	private func presentCreateChannelAlert() {
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
}

	// MARK: - ConversationsListViewProtocol

extension ConversationsListViewController: ConversationsListViewProtocol {
	public func insert(at newIndexPath: IndexPath) {
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
	
	public func delete(at indexPath: IndexPath) {
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	public func update(at indexPath: IndexPath) {
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	public func move(at indexPath: IndexPath, to newIndexPath: IndexPath) {
		tableView.moveRow(at: indexPath, to: newIndexPath)
	}
	
	public func beginUpdates() {
		tableView.beginUpdates()
	}
	
	public func endUpdates() {
		tableView.endUpdates()
	}
	
	public func reload() {
		tableView.reloadData()
	}
    
    public func set(userName: String?, profileImage: UIImage?) {
        if let profileImage = profileImage {
            rightBarButton.setImage(profileImage.circleMasked?.resize(width: barButtonSize, height: barButtonSize), for: .normal)
        } else if let userName = userName, let image = UIImage.textImage(text: userName.getCapitalLetters()) {
            rightBarButton.setImage(image.resize(width: barButtonSize, height: barButtonSize), for: .normal)
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

	// MARK: - UIViewControllerTransitioningDelegate

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animationController.set(animationType: .present)
		return animationController
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animationController.set(animationType: .dismiss)
		return animationController
	}
}
