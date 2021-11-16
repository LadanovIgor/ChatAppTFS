//
//  AssemblyBuilder.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController 
	func createConversationModule(channelId: String, userId: String, databaseService: DatabaseServiceProtocol?, router: RouterProtocol) -> UIViewController
	func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController
	func createUserProfileModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
	
	private var databaseService: DatabaseServiceProtocol
	
	init(databaseService: DatabaseServiceProtocol) {
		self.databaseService = databaseService
	}

	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationsListPresenter(router: router, localStorage: localStorage, databaseService: databaseService)
		let viewController = ConversationsListViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
	
	func createConversationModule(channelId: String, userId: String, databaseService: DatabaseServiceProtocol?, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationPresenter(channelId: channelId, userId: userId, databaseService: databaseService, router: router)
		let viewController = ConversationViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
	
	func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController {
		let presenter = ThemePresenter(router: router)
		let viewController = ThemeViewController(presenter: presenter)
		presenter.set(view: viewController)
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
