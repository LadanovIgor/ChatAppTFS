//
//  Router.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

protocol RouterMain {
	var navigationController: UINavigationController? { get set }
	var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
	func initialScreen(localStorage: StoredLocally?)
	func pushConversationScreen(channelId: String, userId: String)
	func presentThemeScreen(from view: ConversationsListViewProtocol?, themeSelected: ThemeClosure?)
	func presentUserProfileScreen(from view: ConversationsListViewProtocol?, with localStorage: StoredLocally?)
	func popToRoot()
	func dismiss(_ viewController: UIViewController?)
}

final class Router: RouterProtocol {
	
	var navigationController: UINavigationController?
	var assemblyBuilder: AssemblyBuilderProtocol?
	
	init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
		self.assemblyBuilder = assemblyBuilder
		self.navigationController = navigationController
	}
	
	func initialScreen(localStorage: StoredLocally?) {
		guard let navigationController = navigationController,
			  let conversationsListViewController = assemblyBuilder?.createConversationsListModule(localStorage: localStorage, router: self) else {
			return
		}
		navigationController.viewControllers = [conversationsListViewController]
	}
	
	func pushConversationScreen(channelId: String, userId: String) {
		guard let navigationController = navigationController,
			  let conversationViewController = assemblyBuilder?.createConversationModule(channelId: channelId, userId: userId, router: self) else {
			return
		}
		navigationController.pushViewController(conversationViewController, animated: true)
	}
	
	func presentThemeScreen(from view: ConversationsListViewProtocol?, themeSelected: ThemeClosure?) {
		guard let viewController = view as? UIViewController,
			  let themeViewController = assemblyBuilder?.createThemeModule(themeSelected: themeSelected, router: self) else {
				  return
			  }
		viewController.present(themeViewController, animated: true)
	}
	
	func presentUserProfileScreen(from view: ConversationsListViewProtocol?, with localStorage: StoredLocally?) {
		guard let viewController = view as? UIViewController,
			  let userProfileViewController = assemblyBuilder?.createUserProfileModule(localStorage: localStorage, router: self) else {
				  return
			  }
		viewController.present(userProfileViewController, animated: true)
	}
	
	func dismiss(_ viewController: UIViewController?) {
		viewController?.dismiss(animated: true, completion: nil)
	}
	
	func popToRoot() {
		navigationController?.popViewController(animated: true)
	}
}
