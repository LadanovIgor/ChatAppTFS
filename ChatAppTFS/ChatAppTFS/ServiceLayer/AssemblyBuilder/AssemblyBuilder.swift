//
//  AssemblyBuilder.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import UIKit

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
	
	typealias ChatServiceProtocol = MessagesServiceProtocol & ChannelsServiceProtocol
	
	// MARK: - Properties & Init

	private var chatService: ChatServiceProtocol
	
	init(chatService: ChatServiceProtocol) {
		self.chatService = chatService
	}
	
	// MARK: - Public

	func createConversationsListModule(localStorage: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationsListPresenter(router: router, localStorage: localStorage, channelsService: chatService)
		let viewController = ConversationsListViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
	
	func createConversationModule(channelId: String, userId: String, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationPresenter(channelId: channelId, userId: userId, messagesService: chatService, router: router)
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
	
	func createUserProfileModule(storageService: StoredLocally?, router: RouterProtocol) -> UIViewController {
		let presenter = ProfilePresenter(storageService: storageService, router: router)
		let viewController = UserProfileViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
}
