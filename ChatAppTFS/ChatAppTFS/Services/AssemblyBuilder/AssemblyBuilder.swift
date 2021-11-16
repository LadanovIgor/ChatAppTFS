//
//  AssemblyBuilder.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController 
	func createConversationModule(channelId: String, userId: String, router: RouterProtocol) -> UIViewController
	func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController
	func createUserProfileModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
	
	var databaseManager: DatabaseProtocol
	var firestoreManager: FireStorable
	
	init(databaseManager: DatabaseProtocol, firestoreManager: FireStorable) {
		self.databaseManager = databaseManager
		self.firestoreManager = firestoreManager
	}

	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let databaseService = DatabaseService(databaseManager: databaseManager, firestoreManager: firestoreManager)
		let presenter = ConversationsListPresenter(router: router, localStorage: localStorage, databaseService: databaseService)
		databaseService.databaseUpdater = presenter
		let viewController = ConversationsListViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
	
	func createConversationModule(channelId: String, userId: String, router: RouterProtocol) -> UIViewController {
		let databaseService = DatabaseService(with: channelId, databaseManager: databaseManager, firestoreManager: firestoreManager)
		let presenter = ConversationPresenter(channelId: channelId, userId: userId, databaseService: databaseService, router: router)
		databaseService.databaseUpdater = presenter
		let viewController = ConversationViewController(presenter: presenter)
		presenter.set(viewController: viewController)
		return viewController
	}
	
	func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController {
		let presenter = ThemePresenter(router: router)
		let viewController = ThemeViewController(presenter: presenter)
		presenter.view = viewController
		presenter.themeSelected = themeSelected
		return viewController
	}
	
	func createUserProfileModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let presenter = ProfilePresenter(localStorage: localStorage, router: router)
		let viewController = UserProfileViewController(presenter: presenter)
		presenter.view = viewController
		return viewController
	}
}
