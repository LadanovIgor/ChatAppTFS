//
//  ThemeProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import UIKit

protocol ThemeProtocol {
	static var name: String { get }
	var tint: UIColor { get }
	var backgroundColor: UIColor { get }
	var textColor: UIColor { get }
	var barStyle: UIBarStyle { get }
	var secondaryBackground: UIColor { get }
	func apply(for application: UIApplication)
}

extension ThemeProtocol {
	func apply(for application: UIApplication) {
		application.keyWindow?.tintColor = tint
		UINavigationBar.appearance().barStyle = barStyle
		UINavigationBar.appearance().barTintColor = backgroundColor
		UINavigationBar.appearance().tintColor = tint
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: textColor]
		UINavigationBar.appearance().backgroundColor = backgroundColor
		UITableView.appearance().backgroundColor = backgroundColor
		UILabel.appearance().textColor = textColor
		UIView.appearance(whenContainedInInstancesOf: [UITableView.self]).backgroundColor = backgroundColor
		UIView.appearance(whenContainedInInstancesOf: [ConversationViewController.self]).backgroundColor = backgroundColor
		UIView.appearance(whenContainedInInstancesOf: [ConversationsListViewController.self]).backgroundColor = backgroundColor
		AppView.appearance().backgroundColor = backgroundColor
		ProfileHeaderView.appearance().backgroundColor = secondaryBackground
		UIVisualEffectView.appearance().backgroundColor = backgroundColor
		SendMessageView.appearance().backgroundColor = secondaryBackground
		AppButton.appearance().backgroundColor = secondaryBackground
		UIActivityIndicatorView.appearance().tintColor = tint
		application.windows.reload()
	}
}
