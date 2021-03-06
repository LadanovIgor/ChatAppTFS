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
    func apply(for application: UIApplication, with animation: Bool)
}

extension ThemeProtocol {
    func apply(for application: UIApplication, with animation: Bool) {
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
		UIView.appearance(whenContainedInInstancesOf: [PicturesViewController.self]).backgroundColor = backgroundColor
		UICollectionView.appearance().backgroundColor = backgroundColor
		AppCircleView.appearance().backgroundColor = backgroundColor
 		AppView.appearance().backgroundColor = backgroundColor
		AppHeaderView.appearance().backgroundColor = secondaryBackground
		UIVisualEffectView.appearance().backgroundColor = backgroundColor
		SendMessageView.appearance().backgroundColor = secondaryBackground
		AppButton.appearance().backgroundColor = secondaryBackground
		UIActivityIndicatorView.appearance().tintColor = tint
        
        if animation {
            UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                application.windows.reload()
            }
        } else {
            application.windows.reload()
        }
	}
}
