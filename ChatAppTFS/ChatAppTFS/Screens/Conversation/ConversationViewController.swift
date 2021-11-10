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
		guard let channelId = channel?.identifier else { fatalError("Channel None!") }
		let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "channel.identifier = %@", channelId)
		let sortDescriptor = NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.fetchBatchSize = 10
		let fetchResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: DatabaseManager.shared.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchResultController.delegate = self
		return fetchResultController
	}()
	
	private let tableView = UITableView(frame: .zero, style: .grouped)
	private let sendMessageView = SendMessageView()
	private var bottomConstraint: NSLayoutConstraint?
	private var channel: DBChannel?
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
				if isKeyboardShowing {
					self.tableView.scrollToBottom(isAnimated: false)
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
		let messages = documents.compactMap { (document) -> Message? in
			do {
				let message = try document.data(as: Message.self)
				return message
			} catch {
				print(error.localizedDescription)
				return nil
			}
		}
		saveToDatabase(messages)
	}
	
	private func saveToDatabase(_ messages: [Message]) {
		guard let channel = channel, let channelId = channel.identifier else {
			fatalError("Channel None!")
		}
		DatabaseManager.shared.updateDatabase(with: messages, toChannel: channelId) { [weak self] result in
			switch result {
			case .success:
				self?.performFetching()
				DispatchQueue.main.async {
					self?.tableView.reloadData()
					self?.tableView.scrollToBottom()
				}
			case .failure(let error): print(error.localizedDescription)
			}
		}
	}

	private func performFetching() {
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
		guard let sections = fetchResultController.sections else {
			fatalError("No sections in fetchedResultController")
		}
		let sectionInfo = sections[section]
		return sectionInfo.numberOfObjects
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
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { fatalError("Insert object error! NewIndexPath none") }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { fatalError("Delete object error! IndexPath none") }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .update:
			guard let indexPath = indexPath else { fatalError("Update object error! IndexPath none") }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		case .move:
			guard let newIndexPath = newIndexPath, let indexPath = indexPath else {
				fatalError("Move object error! IndexPath or newIndexPath none")
			}
			tableView.moveRow(at: indexPath, to: newIndexPath)
		default: break
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
}
