//
//  RouterProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 17.11.2021.
//

import Foundation

protocol RouterMain {
	var navigationController: UINavigationController? { get set }
	var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
	func initialScreen(storageService: StoredLocally?)
	func pushConversationScreen(channelId: String, userId: String)
	func presentThemeScreen(from view: ConversationsListViewProtocol?, themeSelected: ThemeClosure?)
	func presentUserProfileScreen(from view: ConversationsListViewProtocol?, with storageService: StoredLocally?)
	func dismiss(_ viewController: UIViewController?)
}
