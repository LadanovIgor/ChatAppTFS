//
//  Router.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

final class Router: RouterProtocol {
	
	// MARK: - Properties & Init
	
	var navigationController: UINavigationController?
	var assemblyBuilder: AssemblyBuilderProtocol?
	
	init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
		self.assemblyBuilder = assemblyBuilder
		self.navigationController = navigationController
	}
	
	// MARK: - Public
	
	func initialScreen() {
		guard let navigationController = navigationController,
			  let conversationsListViewController = assemblyBuilder?.createConversationsListModule(router: self) else {
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
		guard let themeViewController = assemblyBuilder?.createThemeModule(themeSelected: themeSelected, router: self),
                let viewController = view as? UIViewController else {
				  return
			  }
		viewController.present(themeViewController, animated: true)
	}
	
	func presentUserProfileScreen(from view: ConversationsListViewProtocol?, with storageService: StoredLocally?) {
		guard let userProfileViewController = assemblyBuilder?.createUserProfileModule(router: self),
              let viewController = view as? ConversationsListViewController else {
				  return
			  }
		userProfileViewController.transitioningDelegate = viewController
		viewController.present(userProfileViewController, animated: true)
	}
	
	func presentPicturesScreen(for view: ProfileViewProtocol?, pictureSelected: @escaping (Data) -> Void) {
		guard let picturesViewController = assemblyBuilder?.createPicturesModule(pictureSelected: pictureSelected, router: self),
              let viewController = view else {
				  return
			  }
		viewController.present(picturesViewController, animated: true)
	}
	
	func presentPicturesScreen(for view: ConversationViewProtocol?, pictureSelectedUrl: @escaping (String) -> Void) {
		guard let viewController = view as? UIViewController,
			  let picturesViewController = assemblyBuilder?.createPicturesModule(pictureSelectedURL: pictureSelectedUrl, router: self) else {
				  return
			  }
		viewController.present(picturesViewController, animated: true)
	}
	
    func dismiss(_ viewController: UIViewController?) {
		viewController?.dismiss(animated: true, completion: nil)
	}
}
