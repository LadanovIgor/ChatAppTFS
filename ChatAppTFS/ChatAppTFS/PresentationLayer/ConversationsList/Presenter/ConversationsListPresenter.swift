//
//  ConversationListController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import CoreData

class ConversationsListPresenter: NSObject, ConversationsListPresenterProtocol {
	
	// MARK: - Properties
	
	private weak var view: ConversationsListViewProtocol?
	private var storageService: StoredLocally?
	private var channelsService: ChannelsServiceProtocol?
	private var router: RouterProtocol?
	private var userId: String?
	
	lazy var dataSource: ConversationsListDataSourceProtocol = {
		guard let viewContext = channelsService?.coreDataManager.viewContext else {
			fatalError("Couldn't get context")
		}
		let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchRequest.fetchBatchSize = 10
		let fetchResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchResultController.delegate = self
		guard let viewController = view else {
			fatalError("ConversationListVC None!")
		}
		return ConversationsListDataSource(fetchResultController: fetchResultController, presenter: self)
	}()
	
	// MARK: - Init
	
	init(router: RouterProtocol, storageService: StoredLocally?, channelsService: ChannelsServiceProtocol?) {
		self.router = router
		self.storageService = storageService
		self.channelsService = channelsService
		super.init()
	}
	
	// MARK: - Private

	private func createNewId() {
		userId = UUID().uuidString
		guard let dataId = userId?.data(using: .utf8) else {
			return
		}
		let dict = [Constants.LocalStorage.idKey: dataId]
		storageService?.save(dict) { _ in
			
		}
	}
	
	private func getUserId() {
		let key = Constants.LocalStorage.idKey
		storageService?.loadValue(for: key) { [weak self] result in
			switch result {
			case .success(let data):
				guard let senderId = String(data: data, encoding: .utf8) else {
					self?.createNewId()
					return
				}
				self?.userId = senderId
			case .failure:
				self?.createNewId()
			}
		}
	}
	
	private func changeTheme(for theme: ThemeProtocol) {
		theme.apply(for: UIApplication.shared)
		let themeName = String(describing: type(of: theme).self)
		guard let themeNameData = themeName.data(using: .utf8) else {
			return
		}
		let dict = [Constants.LocalStorage.themeKey: themeNameData]
		storageService?.save(dict) { result in
			switch result {
			case .failure(let error): print(error.localizedDescription)
			case .success: break
			}
		}
	}
	
	private func getUserName() {
		storageService?.loadValue(for: Constants.LocalStorage.nameKey) { [weak self] result in
			switch result {
			case .success(let data):
				guard let text = String(data: data, encoding: .utf8) else {
					return
				}
				DispatchQueue.main.async {
					self?.view?.set(userName: text)
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	// MARK: - Public
	
	public func set(view: ConversationsListViewProtocol) {
		self.view = view
	}
	
	public func viewDidLoad() {
		getUserId()
		getUserName()
	}
	
	public func viewWillAppear() {
		channelsService?.startFetchingChannels()
		channelsService?.databaseUpdater = self
	}
	
	public func viewWillDisappear() {
		channelsService?.stopFetchingChannels()
	}
	
	public func didTapAt(indexPath: IndexPath) {
		let channel = dataSource.fetchResultController.object(at: indexPath)
		guard let router = router, let channelId = channel.identifier, let userId = userId else {
			return
		}
		router.pushConversationScreen(channelId: channelId, userId: userId)
	}
	
	public func leftBarButtonTapped() {
		router?.presentThemeScreen(from: view) { [weak self] theme in
			self?.changeTheme(for: theme)
		}
	}
	
	public func rightBarButtonTapped() {
		router?.presentUserProfileScreen(from: view, with: storageService)
	}

	public func createNewChannel(with name: String) {
		channelsService?.addChannel(with: name)
	}
	
	public func deleteChannel(with channelId: String) {
		channelsService?.deleteChannel(with: channelId)
	}
}

	// MARK: - DatabaseUpdatable

extension ConversationsListPresenter: DatabaseUpdatable {
	public func updateData() {
		dataSource.performFetching()
		DispatchQueue.main.async {
			self.view?.reload()
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
