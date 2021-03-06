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

	private let chatService: ChatServiceProtocol
	private let storageService: StoredLocally
	private let requestSender: RequestSenderProtocol
	
	init(chatService: ChatServiceProtocol, storageService: StoredLocally, requestSender: RequestSenderProtocol) {
		self.chatService = chatService
		self.storageService = storageService
		self.requestSender = requestSender
	}
	
	// MARK: - Public

	func createConversationsListModule(router: RouterProtocol) -> UIViewController {
		let presenter = ConversationsListPresenter(router: router, storageService: storageService, channelsService: chatService)
		let viewController = ConversationsListViewController(presenter: presenter)
		presenter.set(view: viewController)
		return viewController
	}
	
	func createConversationModule(channelId: String, userId: String, router: RouterProtocol) -> UIViewController {
		let presenter = ConversationPresenter(channelId: channelId, userId: userId, messagesService: chatService, requestSender: requestSender, router: router)
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
	
	func createUserProfileModule(router: RouterProtocol) -> UIViewController {
		let presenter = ProfilePresenter(storageService: storageService, router: router)
		let viewController = UserProfileViewController(presenter: presenter)
		viewController.modalPresentationStyle = .custom
		presenter.set(view: viewController)
		return viewController
	}
	
	func createPicturesModule(pictureSelected: @escaping (Data) -> Void, router: RouterProtocol) -> UIViewController {
		let presenter = PicturesPresenter(requestSender: requestSender, router: router)
		let viewController = PicturesViewController(presenter: presenter)
		presenter.set(view: viewController)
		presenter.pictureSelected = pictureSelected
		return viewController
	}
	
	func createPicturesModule(pictureSelectedURL: @escaping (String) -> Void, router: RouterProtocol) -> UIViewController {
		let presenter = PicturesPresenter(requestSender: requestSender, router: router)
		let viewController = PicturesViewController(presenter: presenter)
		presenter.set(view: viewController)
		presenter.pictureSelectedURL = pictureSelectedURL
		return viewController
	}
}
