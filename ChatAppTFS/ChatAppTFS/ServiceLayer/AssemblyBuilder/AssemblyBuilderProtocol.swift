//
//  AssemblyBuilderProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 17.11.2021.
//

import Foundation

protocol AssemblyBuilderProtocol: AnyObject {
	func createConversationsListModule(router: RouterProtocol) -> UIViewController
	func createConversationModule(channelId: String, userId: String, router: RouterProtocol) -> UIViewController
	func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController
	func createUserProfileModule(router: RouterProtocol) -> UIViewController
}
