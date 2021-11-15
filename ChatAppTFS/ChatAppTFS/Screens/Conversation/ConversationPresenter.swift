//
//  ConversationController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import Firebase
import UIKit
import CoreData

class ConversationPresenter: NSObject, DatabaseUpdatable, ConversationPresenterProtocol {
	
	weak var view: ConversationViewController?
	
	var router: RouterProtocol?
	
	lazy var dataSource: ConversationDataSource = {
		guard let channelId = channelId else { fatalError("Channel None!") }
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
	
	private var channelId: String?
	private var senderId: String?
	private var firestoreService: FirestoreServiceProtocol?
	
	init(channelId: String, firestoreService: FirestoreServiceProtocol, router: RouterProtocol) {
		self.channelId = channelId
		self.router = router
		self.firestoreService = firestoreService
		super.init()
		getSenderId()
	}
	
	func set(viewController: ConversationViewController) {
		self.view = viewController
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
	
	func updateData() {
		dataSource.performFetching()
		DispatchQueue.main.async {
			self.view?.reload()
		}
	}
	
	func createNewMessage(with content: String) {
		guard let senderId = senderId else { return }
		firestoreService?.addMessage(with: content, senderId: senderId)
	}
	
}

extension ConversationPresenter: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.beginUpdates()
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
		at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { fatalError("Insert object error! NewIndexPath none") }
			view?.insert(at: newIndexPath)
		case .delete:
			guard let indexPath = indexPath else { fatalError("Delete object error! IndexPath none") }
			view?.delete(at: indexPath)
		case .update:
			guard let indexPath = indexPath else { fatalError("Update object error! IndexPath none") }
			view?.update(at: indexPath)
		case .move:
			guard let newIndexPath = newIndexPath, let indexPath = indexPath else {
				fatalError("Move object error! IndexPath or newIndexPath none")
			}
			view?.move(at: indexPath, to: newIndexPath)
		default: break
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.endUpdates()
	}
}
