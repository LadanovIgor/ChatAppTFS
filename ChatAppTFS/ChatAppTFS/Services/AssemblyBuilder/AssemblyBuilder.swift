//
//  AssemblyBuilder.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController 
	func createConversationModule(channelId: String, router: RouterProtocol) -> UIViewController
	func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController
	func createUserProfileModule(localStorage: StoredLocally?) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {

	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let firestoreService = FirestoreService()
		let presenter = ConversationsListPresenter(router: router, localStorage: localStorage, firestoreService: firestoreService)
		firestoreService.databaseUpdater = presenter
		let viewController = ConversationsListViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
	
	func createConversationModule(channelId: String, router: RouterProtocol) -> UIViewController {
		let firestoreService = FirestoreService(with: channelId)
		let presenter = ConversationPresenter(channelId: channelId, firestoreService: firestoreService, router: router)
		firestoreService.databaseUpdater = presenter
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
	
	func createUserProfileModule(localStorage: StoredLocally?) -> UIViewController {
		let viewController = UserProfileViewController(localStorage: localStorage)
		return viewController
	}
}
