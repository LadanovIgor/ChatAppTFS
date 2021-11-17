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
	func initialScreen(localStorage: StoredLocally?)
	func pushConversationScreen(channelId: String, userId: String, databaseService: DatabaseServiceProtocol?)
	func presentThemeScreen(from view: ConversationsListViewProtocol?, themeSelected: ThemeClosure?)
	func presentUserProfileScreen(from view: ConversationsListViewProtocol?, with localStorage: StoredLocally?)
	func popToRoot()
	func dismiss(_ viewController: UIViewController?)
}
