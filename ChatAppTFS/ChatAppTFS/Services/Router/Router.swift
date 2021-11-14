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
	func initialViewController(localStorage: StoredLocally?)
	func goToConversationScreen(channel: DBChannel)
	func presentThemeScreen(from viewController: UIViewController?, themeSelected: ThemeClosure?)
	func presentUserProfileScreen(from viewController: UIViewController?, with localStorage: StoredLocally?)
	func popToRoot()
	func dismiss(_ viewController: UIViewController?)
}

class Router: RouterProtocol {
	
	var navigationController: UINavigationController?
	var assemblyBuilder: AssemblyBuilderProtocol?
	
	init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
		self.assemblyBuilder = assemblyBuilder
		self.navigationController = navigationController
	}
	
	func initialViewController(localStorage: StoredLocally?) {
		guard let navigationController = navigationController,
			  let conversationsListViewController = assemblyBuilder?.createConversationsListModule(localStorage: localStorage, router: self) else {
			return
		}
		navigationController.viewControllers = [conversationsListViewController]
	}
	
	func goToConversationScreen(channel: DBChannel) {
		guard let navigationController = navigationController,
			  let conversationViewController = assemblyBuilder?.createConversationModule(channel: channel, router: self) else {
			return
		}
		navigationController.pushViewController(conversationViewController, animated: true)
	}
	
	func presentThemeScreen(from viewController: UIViewController?, themeSelected: ThemeClosure?) {
		guard let viewController = viewController,
			  let themeViewController = assemblyBuilder?.createThemeModule(themeSelected: themeSelected) else {
				  return
			  }
		viewController.present(themeViewController, animated: true)
	}
	
	func presentUserProfileScreen(from viewController: UIViewController?, with localStorage: StoredLocally?) {
		guard let viewController = viewController,
			  let userProfileViewController = assemblyBuilder?.createUserProfileModule(localStorage: localStorage) else {
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
