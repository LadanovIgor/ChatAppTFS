//
//  ConversationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationViewController: UIViewController, KeyboardObservable {
	
	// MARK: - Properties
	
	var presenter: ConversationPresenterProtocol?
	let tableView = TouchAnimateTableView(frame: .zero, style: .grouped)
	let sendMessageView = SendMessageView()
	var bottomConstraint: NSLayoutConstraint?
	
	// MARK: - Init
	
	convenience init(presenter: ConversationPresenterProtocol) {
		self.init()
		self.presenter = presenter
	}
	
	deinit {
		stopObserving()
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpBackButton()
		setUpTableView()
		setUpSendMessageView()
		setUpConstraints()
		addKeyboardObservers()
		delegating()
		monitoringMessageSending()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.viewWillAppear()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.viewWillDisappear()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
	}
	
	// MARK: - Private
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = presenter?.dataSource
		sendMessageView.delegate = presenter
	}
	
	private func setUpSendMessageView() {
		view.addSubview(sendMessageView)
		sendMessageView.translatesAutoresizingMaskIntoConstraints = false

	}

	private func addKeyboardObservers() {
		startObserving { [weak self] keyboardHeight, isKeyboardShowing in
			self?.bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
			UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				self?.view.layoutIfNeeded()
			}
		}
	}
	
	private func setUpBackButton() {
		let backButton = UIBarButtonItem()
		backButton.title = "Back"
		backButton.tintColor = UIColor(named: "buttonTitle") ?? .blue
		navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
	}
	
	private func setUpTableView() {
		tableView.estimatedRowHeight = 100.0
		tableView.separatorStyle = .none
		tableView.register(ConversationTableViewCell.nib,
						   forCellReuseIdentifier: ConversationTableViewCell.name)
		tableView.register(PictureMessageTableViewCell.nib,
						   forCellReuseIdentifier: PictureMessageTableViewCell.name)
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
	}
	
	private func setUpConstraints() {
		view.removeConstraints(view.constraints)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			sendMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			sendMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sendMessageView.heightAnchor.constraint(equalToConstant: Constants.ConversationScreen.messageViewHeight),
			sendMessageView.topAnchor.constraint(equalTo: tableView.bottomAnchor)
		])
		bottomConstraint = NSLayoutConstraint(item: sendMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		guard let constraint = bottomConstraint else {
			return
		}
		view.addConstraint(constraint)
	}
	
	private func monitoringMessageSending() {
		sendMessageView.messageSent = { [weak self] text in
			self?.presenter?.createNewMessage(with: text)
		}
	}
}

	// MARK: - ConversationViewProtocol

extension ConversationViewController: ConversationViewProtocol {
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
}

	// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		sendMessageView.stopEditing()
	}
}
