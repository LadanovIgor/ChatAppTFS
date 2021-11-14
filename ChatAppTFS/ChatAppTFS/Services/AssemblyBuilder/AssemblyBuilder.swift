//
//  AssemblyBuilder.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController 
	func createConversationModule(channel: DBChannel, router: RouterProtocol) -> UIViewController
	func createThemeModule(themeSelected: ThemeClosure?) -> UIViewController
	func createUserProfileModule(localStorage: StoredLocally?) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {

	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationsListPresenter(router: router, localStorage: localStorage)
		let viewController = ConversationsListViewController(presenter: presenter)
		presenter.set(viewController: viewController)
		return viewController
	}
	
	func createConversationModule(channel: DBChannel, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationController(channel: channel, router: router)
		let viewController = ConversationViewController(controller: presenter)
		presenter.set(viewController: viewController)
		return viewController
	}
	
	func createThemeModule(themeSelected: ThemeClosure?) -> UIViewController {
		let viewController = ThemeViewController()
		viewController.themeSelected = themeSelected
		return viewController
	}
	
	func createUserProfileModule(localStorage: StoredLocally?) -> UIViewController {
		let viewController = UserProfileViewController(localStorage: localStorage)
		return viewController
	}
}
