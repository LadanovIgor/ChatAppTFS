//
//  ConversationListController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
import FirebaseFirestoreSwift

protocol ConversationsListViewProtocol: AnyObject {
	var presenter: ConversationsListPresenterProtocol? { get set }
}

protocol ConversationsListPresenterProtocol: AnyObject {
	var view: ConversationsListViewProtocol? { get set }
	var localStorage: StoredLocally? { get set }
	var router: RouterProtocol? { get set }
	var dataSource: ConversationDataSource { get set }
	var tableView: UITableView? { get set }
	init(router: RouterProtocol)
	func set(view: ConversationsListViewProtocol)
	func changeTheme(for theme: ThemeProtocol)
	func createNewChannel(with name: String)
	func leftBarButtonTapped()
	func rightBarButtonTapped()
	func getUserName(completion: ResultClosure<String>)
}

class ConversationsListPresenter: NSObject {
	weak var view: ConversationsListViewProtocol?
	
	private lazy var db = Firestore.firestore()
	lazy var reference = db.collection("channels")
	weak var viewController: ConversationsListViewController?
	
	var router: RouterProtocol?
	var localStorage: StoredLocally?
	
	init(router: RouterProtocol, localStorage: StoredLocally?) {
		self.router = router
		self.localStorage = localStorage
	}
	
	private lazy var dataSource: ConversationListDataSource = {
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
		guard let viewController = viewController else {
			fatalError("ConversationListVC None!")
		}
		return ConversationListDataSource(fetchResultController: fetchResultController, controller: self)
	}()
	
	private lazy var tableView = viewController?.tableView

	func viewDidLoad() {
		addFirestoreListener()
		delegating()
	}
	
	func set(viewController: ConversationsListViewController) {
		self.viewController = viewController
	}
	
	private func delegating() {
		tableView?.delegate = self
		tableView?.dataSource = dataSource
	}

	func leftBarButtonTapped() {
		router?.presentThemeScreen(from: viewController) { [weak self] theme in
			self?.changeTheme(for: theme)
		}
	}
	
	func rightBarButtonTapped() {
		router?.presentUserProfileScreen(from: viewController, with: localStorage)
	}
	
	func set(view: ConversationsListViewProtocol) {
		self.view = view
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
					self?.viewController?.tableView.reloadData()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}

// MARK: - UITableViewDelegate

extension ConversationsListPresenter: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return ConversationsListTableViewCell.preferredHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let channel = dataSource.fetchResultController.object(at: indexPath)
		router?.goToConversationScreen(channel: channel)
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
			self?.viewController?.presentCreateChannelAlert()
		}
		return headerView
	}
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListPresenter: NSFetchedResultsControllerDelegate {
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
