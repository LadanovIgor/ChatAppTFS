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
	
	weak var view: ConversationViewProtocol?
	
	var router: RouterProtocol?
	
	lazy var dataSource: ConversationDataSourceProtocol = {
		guard let channelId = channelId else { fatalError("Channel None!") }
		guard let viewContext = databaseService?.coreDataManager.viewContext else {
			fatalError("FirestoreService None")
		}
		let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "channel.identifier = %@", channelId)
		let sortDescriptor = NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.fetchBatchSize = 10
		let fetchResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchResultController.delegate = self
		return ConversationDataSource(fetchResultController: fetchResultController, senderId: userId)
	}()
	
	private var channelId: String?
	private var userId: String?
	private var databaseService: DatabaseServiceProtocol?
	
	init(channelId: String, userId: String, databaseService: DatabaseServiceProtocol?, router: RouterProtocol) {
		self.channelId = channelId
		self.userId = userId
		self.router = router
		self.databaseService = databaseService
		super.init()
		
	}
	
	func viewWillAppear() {
		guard let channelId = channelId else { fatalError("Channel None!") }
		self.databaseService?.startFetchingMessages(from: channelId)
		databaseService?.databaseUpdater = self
	}
	
	func viewWillDisappear() {
		databaseService?.stopFetchingMessages()
	}
	
	func set(view: ConversationViewProtocol) {
		self.view = view
	}
	
	func updateData() {
		dataSource.performFetching()
		DispatchQueue.main.async {
			self.view?.reload()
		}
	}
	
	func createNewMessage(with content: String) {
		guard let senderId = userId else { return }
		databaseService?.addMessage(with: content, senderId: senderId)
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
