//
//  ConversationListController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import Firebase
import FirebaseAuth
import CoreData
import FirebaseFirestoreSwift

class ConversationsListPresenter: NSObject, ConversationsListPresenterProtocol {

	private lazy var db = Firestore.firestore()
	lazy var reference = db.collection("channels")
	weak var view: ConversationsListViewProtocol?
	var router: RouterProtocol?
	var localStorage: StoredLocally?
	
	init(router: RouterProtocol, localStorage: StoredLocally?) {
		self.router = router
		self.localStorage = localStorage
	}
	
	lazy var dataSource: ConversationListDataSource = {
		let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.fetchBatchSize = 10
		let fetchResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: DatabaseManager.shared.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchResultController.delegate = self
		guard let viewController = view else {
			fatalError("ConversationListVC None!")
		}
		return ConversationListDataSource(fetchResultController: fetchResultController, controller: self)
	}()
	
	func viewDidLoad() {
		addFirestoreListener()
	}
	
	func didTapAt(indexPath: IndexPath) {
		let channel = dataSource.fetchResultController.object(at: indexPath)
		router?.goToConversationScreen(channel: channel)
	}
	
	func set(view: ConversationsListViewProtocol) {
		self.view = view
	}
	
	func leftBarButtonTapped() {
		router?.presentThemeScreen(from: view) { [weak self] theme in
			self?.changeTheme(for: theme)
		}
	}
	
	func rightBarButtonTapped() {
		router?.presentUserProfileScreen(from: view, with: localStorage)
	}

	func createNewChannel(with name: String) {
		reference.addDocument(data: ["name": name, "lastActivity": Timestamp(date: Date())])
	}
	
	func getUserName(completion: @escaping (ResultClosure<String>)) {
		localStorage?.getValue(for: Constants.LocalStorage.nameKey) { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let data):
					guard let text = String(data: data, encoding: .utf8) else {
						completion(.failure(StoredLocallyError.failureEncodingData))
						return
					}
					completion(.success(text))
				case .failure(let error): completion(.failure(error))
				}
			}
		}
	}
	
	func changeTheme(for theme: ThemeProtocol) {
		theme.apply(for: UIApplication.shared)
		let themeName = String(describing: type(of: theme).self)
		guard let themeNameData = themeName.data(using: .utf8) else {
			return
		}
		let dict = [Constants.LocalStorage.themeKey: themeNameData]
		localStorage?.saveLocally(dict) { result in
			switch result {
			case .failure(let error): print(error.localizedDescription)
			case .success: break
			}
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
		let channels = documents.compactMap { (document) -> Channel? in
			do {
				let channel = try document.data(as: Channel.self)
				guard let channel = channel else {
					fatalError("Channel decoding error")
				}
				return channel
			} catch {
				print("Some joker created channel with the wrong value type")
				return nil
			}
		}
		updateDatabase(with: channels)
	}

	private func updateDatabase(with channels: [Channel]) {
		DatabaseManager.shared.updateDatabase(with: channels) { [weak self] result in
			switch result {
			case .success:
					self?.dataSource.performFetching()
				DispatchQueue.main.async {
					self?.view?.reload()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListPresenter: NSFetchedResultsControllerDelegate {
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
