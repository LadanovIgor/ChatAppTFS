//
//  ConversationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//
import Firebase
import UIKit
import CoreData

class ConversationViewController: UIViewController, KeyboardObservable {
	
	// MARK: - Properties

	private lazy var db = Firestore.firestore()
	private lazy var reference: CollectionReference = {
		guard let channelIdentifier = channel?.identifier else { fatalError("Channel None!") }
		return db.collection("channels").document(channelIdentifier).collection("messages")
	}()
	
	lazy var fetchResultController: NSFetchedResultsController<DBMessage> = {
		guard let channelIdentifier = channel?.identifier else { fatalError("Channel None!") }
		let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "channel.identifier = %@", channelIdentifier)
		let sortDescriptor = NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let fetchResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: DatabaseManager.shared.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		return fetchResultController
	}()
	
	private let tableView = UITableView(frame: .zero, style: .grouped)
	private let sendMessageView = SendMessageView()
	private var bottomConstraint: NSLayoutConstraint?
	private var channel: DBChannel?
	private var messages = [Message]()
	private var senderId: String?
	
	// MARK: - Init
	
	init(channel: DBChannel) {
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
		getSenderId()
		setUpBackButton()
		setUpTableView()
		setUpSendMessageView()
		setUpConstraints()
		addKeyboardObservers()
		loadMessages()
		fetchMessages()
		performFetching()
	}
	
	// MARK: - Private
	
	private func setUpSendMessageView() {
		view.addSubview(sendMessageView)
		sendMessageView.translatesAutoresizingMaskIntoConstraints = false
		sendMessageView.messageSent = { [weak self] text in
			self?.createNewMessage(with: text)
		}
	}
	
	private func createNewMessage(with content: String) {
		guard let senderId = senderId else { return }
		do {
			_ = try reference.addDocument(from: Message(content: content, senderId: senderId))
		} catch {
			print(error.localizedDescription)
		}
		
//		reference.addDocument(data: [
//			Constants.FirebaseKey.content: text,
//			Constants.FirebaseKey.data: Timestamp(date: Date()),
//			Constants.FirebaseKey.senderId: senderId,
//			Constants.FirebaseKey.senderName: "I.Ladanov"])
		messages = [Message]()
	}
	
	private func getSenderId() {
		let key = Constants.LocalStorage.idKey
		LocalStorageManager.shared.getValue(for: key, completion: { [weak self] result in
			switch result {
			case .success(let data):
				guard let senderId = String(data: data, encoding: .utf8) else {
					self?.createNewId()
					return
				}
				self?.senderId = senderId
			case .failure:
				self?.createNewId()
			}
		})
	}
	
	private func createNewId() {
		senderId = UUID().uuidString
		guard let dataId = senderId?.data(using: .utf8) else {
			return
		}
		let dict = [Constants.LocalStorage.idKey: dataId]
		LocalStorageManager.shared.saveLocally(dict) { _ in
			
		}
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
		let views = ["tableView": tableView, "newMessageView": sendMessageView]
		let metrics = ["viewHeight": Constants.ConversationScreen.messageViewHeight]
		
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView][newMessageView(viewHeight)]",
			metrics: metrics,
			views: views))
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[newMessageView]|",
			metrics: metrics,
			views: views))
		bottomConstraint = NSLayoutConstraint(item: sendMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
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
				print(CustomFirebaseError.snapshotNone.localizedDescription)
				return
			}
			self?.getMessages(from: documents)
		}
	}
	
	private func getMessages(from documents: [QueryDocumentSnapshot]) {
		messages = documents.compactMap { (document) -> Message? in
			do {
				let message = try document.data(as: Message.self)
				return message
			} catch {
				
				print(error.localizedDescription)
				return nil
			}
		}
		
//		documents.forEach { messages.append(Message(with: $0)) }
		messages.sort { $0.created < $1.created }
		saveToDatabase()
		tableView.reloadData()
		tableView.scrollToBottom()
	}
	
	private func saveToDatabase() {
		guard let channel = channel, let channelId = channel.identifier else {
			fatalError("Channel None!")
		}
		DatabaseManager.shared.save(messages: messages, toChannel: channelId) { [weak self] result in
			switch result {
			case .success:
					do {
						try self?.fetchResultController.performFetch()
						DispatchQueue.main.async {
							self?.tableView.reloadData()
							self?.tableView.scrollToBottom()
						}
					} catch {
						print(error.localizedDescription)
					}
			case .failure(let error): print(error.localizedDescription)
			}
		}
	}
	
	private func fetchMessages() {
		guard let channel = channel, let channelId = channel.identifier else {
			fatalError("Channel None!")
		}
		DatabaseManager.shared.fetchMessagesFrom(channelId: channelId) { result in
			switch result {
			case .success: break
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	private func performFetching() {
		fetchResultController.delegate = self
		do {
			try fetchResultController.performFetch()
		} catch {
			print(error.localizedDescription)
		}
	}
}

	// MARK: - UITableViewDelegate and UITableViewDataSource

extension ConversationViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		sendMessageView.stopEditing()
	}
}

extension ConversationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationTableViewCell.name,
			for: indexPath) as? ConversationTableViewCell else {
				return UITableViewCell()
			}
		let message = fetchResultController.object(at: indexPath)
		cell.configure(with: message, senderId: senderId ?? "")
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchResultController.sections?[section]
		return sectionInfo?.numberOfObjects ?? 0
	}
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
		at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		guard let indexPath = indexPath else {
			return
		}
		
		switch type {
		case .insert: tableView.insertRows(at: [indexPath], with: .automatic)
		case .delete:
				
				tableView.deleteRows(at: [indexPath], with: .automatic)
		case .update: tableView.reloadRows(at: [indexPath], with: .automatic)
		case .move:
			guard let newIndexPath = newIndexPath else {
				return
			}
			tableView.moveRow(at: indexPath, to: newIndexPath)
		default: break
		}

	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
}
