//
//  ConversationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//
import Firebase
import UIKit

class ConversationViewController: UIViewController, KeyboardObservable {
	
	// MARK: - Properties

	private lazy var db = Firestore.firestore()
	private lazy var reference: CollectionReference = {
		guard let channelIdentifier = channel?.identifier else { fatalError() }
		return db.collection("channels").document(channelIdentifier).collection("messages")
	}()
	
	private let tableView = UITableView(frame: .zero, style: .grouped)
	private let newMessageView = NewMessageView()
	private var bottomConstraint: NSLayoutConstraint?
	private var channel: Channel?
	private var messages = [Message]()
	
	// MARK: - Init
	
	init(channel: Channel) {
		self.channel = channel
		super.init(nibName: nil, bundle: nil)
		self.title = channel.name
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		stopObserving()
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpBackButton()
		setUpTableView()
		setUpNewMessageView()
		setUpConstraints()
		addKeyboardObservers()
		loadMessages()
	}
	
	// MARK: - Private
	
	private func setUpNewMessageView() {
		view.addSubview(newMessageView)
		newMessageView.translatesAutoresizingMaskIntoConstraints = false
		newMessageView.messageSent = { [weak self] text in
			self?.createNewMessage(with: text)
		}
	}
	
	private func createNewMessage(with text: String) {
		print(text)
		reference.addDocument(data: ["content": text, "created": Timestamp(date: Date()), "senderName": "Test"])
//		tableView.reloadData()
	}

	private func addKeyboardObservers() {
		startObserving { [weak self] keyboardHeight, isKeyboardShowing in
			self?.bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
			UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				self?.view.layoutIfNeeded()
			} completion: { [weak self] _ in
				guard let self = self else { return }
				if isKeyboardShowing, self.messages.count > 0 {
					let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
					self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
				}
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
		tableView.separatorStyle = .none
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ConversationTableViewCell.nib,
						   forCellReuseIdentifier: ConversationTableViewCell.name)
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
	}
	
	private func setUpConstraints() {
		view.removeConstraints(view.constraints)
		let views = ["tableView": tableView, "newMessageView": newMessageView]
		let metrics = ["viewHeight": Constants.ConversationScreen.messageViewHeight]
		
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView][newMessageView(viewHeight)]",
			metrics: metrics,
			views: views))
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[newMessageView]|",
			metrics: metrics,
			views: views))
		bottomConstraint = NSLayoutConstraint(item: newMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		guard let constraint = bottomConstraint else {
			return
		}
		view.addConstraint(constraint)
	}
	
	private func loadMessages() {
		reference.addSnapshotListener { [weak self] snapshot, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let documents = snapshot?.documents else {
				return
			}
			self?.getMessages(from: documents)
		}
	}
	
	private func getMessages(from documents: [QueryDocumentSnapshot]) {
		
		for document in documents {
			let data = document.data()
			let content = data["content"] as? String ?? ""
			let senderId = data["senderId"] as? String ?? ""
			let created = (data["created"] as? Timestamp)?.dateValue() ?? Date()
			let senderName = data["senderName"] as? String ?? ""
			print("content: \(content)  senderId: \(senderId)")
			print("------------------------------------------------------------")
			messages.append(Message(content: content, created: created, senderId: senderId, senderName: senderName))
		}
		messages.sort { $0.created < $1.created }
		tableView.reloadData()
		tableView.scrollToBottom()
	}
}

	// MARK: - UITableViewDelegate and UITableViewDataSource

extension ConversationViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		newMessageView.stopEditing()
	}
}

extension ConversationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationTableViewCell.name,
			for: indexPath) as? ConversationTableViewCell else {
				return UITableViewCell()
			}
		let message = messages[indexPath.row]
		cell.configure(with: message)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
}
