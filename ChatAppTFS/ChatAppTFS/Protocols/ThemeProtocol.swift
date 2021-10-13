//
//  ThemeProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import UIKit

protocol ThemeProtocol {
	var tint: UIColor { get }
	var backgroundColor: UIColor { get }
	var separatorColor: UIColor { get }
	var labelColor: UIColor { get }
	var barStyle: UIBarStyle { get }
	
	func apply(for application: UIApplication)
}

extension ThemeProtocol {
	func apply(for application: UIApplication) {
		application.keyWindow?.tintColor = tint
		UINavigationBar.appearance().barStyle = barStyle
		UINavigationBar.appearance().barTintColor = backgroundColor
		UINavigationBar.appearance().tintColor = tint
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : labelColor]
		UINavigationBar.appearance().backgroundColor = backgroundColor
		UITableViewHeaderFooterView.appearance().tintColor = labelColor
		UITableView.appearance().separatorColor = separatorColor
		UITableView.appearance().backgroundColor = backgroundColor
		UILabel.appearance().textColor = labelColor
		UIView.appearance(whenContainedInInstancesOf: [UITableView.self]).backgroundColor = backgroundColor
		UIVisualEffectView.appearance().backgroundColor = backgroundColor

		application.windows.reload()
	}
}

