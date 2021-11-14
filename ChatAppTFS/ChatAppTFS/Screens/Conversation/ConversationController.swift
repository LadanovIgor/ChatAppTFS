//
//  ConversationController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import Firebase
import UIKit
import CoreData

class ConversationController: NSObject, LifeCycleProtocol {
	private lazy var db = Firestore.firestore()
	private lazy var reference: CollectionReference = {
		guard let channelIdentifier = channel?.identifier else { fatalError("Channel None!") }
		return db.collection("channels").document(channelIdentifier).collection("messages")
	}()
	
	weak var viewController: ConversationViewController?
	private lazy var tableView = viewController?.tableView
	
	var router: RouterProtocol?
	
	private lazy var dataSource: ConversationDataSource = {
		guard let channelId = channel?.identifier else { fatalError("Channel None!") }
		let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "channel.identifier = %@", channelId)
		let sortDescriptor = NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.fetchBatchSize = 10
		let fetchResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: DatabaseManager.shared.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchResultController.delegate = self
		return ConversationDataSource(fetchResultController: fetchResultController, senderId: senderId)
	}()
	
	private var channel: DBChannel?
	private var senderId: String?

	init(channel: DBChannel, router: RouterProtocol) {
		self.channel = channel
		self.router = router
	}
	
	func viewDidLoad() {
		getSenderId()
		loadMessages()
		performFetching()
		delegating()
		monitoringMessageSending()
	}
	
	func set(viewController: ConversationViewController) {
		self.viewController = viewController
	}
	
	private func monitoringMessageSending() {
		viewController?.sendMessageView.messageSent = { [weak self] text in
			self?.createNewMessage(with: text)
		}
	}
	
	private func delegating() {
		tableView?.delegate = self
		tableView?.dataSource = dataSource
	}
	
	private func getSenderId() {
		let key = Constants.LocalStorage.idKey
		LocalStorageService().getValue(for: key, completion: { [weak self] result in
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
		LocalStorageService().saveLocally(dict) { _ in
			
		}
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
					self?.tableView?.reloadData()
				}
			case .failure(let error): print(error.localizedDescription)
			}
		}
	}

	private func performFetching() {
		do {
			try dataSource.fetchResultController.performFetch()
		} catch {
			print(error.localizedDescription)
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
	
}

extension ConversationController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewController?.sendMessageView.stopEditing()
	}
}

extension ConversationController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView?.beginUpdates()
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
		at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { fatalError("Insert object error! NewIndexPath none") }
			tableView?.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { fatalError("Delete object error! IndexPath none") }
			tableView?.deleteRows(at: [indexPath], with: .automatic)
		case .update:
			guard let indexPath = indexPath else { fatalError("Update object error! IndexPath none") }
			tableView?.reloadRows(at: [indexPath], with: .automatic)
		case .move:
			guard let newIndexPath = newIndexPath, let indexPath = indexPath else {
				fatalError("Move object error! IndexPath or newIndexPath none")
			}
			tableView?.moveRow(at: indexPath, to: newIndexPath)
		default: break
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView?.endUpdates()
	}
}
