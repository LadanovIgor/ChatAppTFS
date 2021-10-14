//
//  ThemeProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import UIKit

protocol ThemeProtocol {
	var themeName: String { get }
	var tint: UIColor { get }
	var backgroundColor: UIColor { get }
	var textColor: UIColor { get }
	var barStyle: UIBarStyle { get }
	var newMessageBackground: UIColor { get }
	func apply(for application: UIApplication)
	func logThemeChanging()
}

extension ThemeProtocol {
	func apply(for application: UIApplication) {
		application.keyWindow?.tintColor = tint
		UINavigationBar.appearance().barStyle = barStyle
		UINavigationBar.appearance().barTintColor = backgroundColor
		UINavigationBar.appearance().tintColor = tint
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : textColor]
		UINavigationBar.appearance().backgroundColor = backgroundColor
		UITableViewHeaderFooterView.appearance().tintColor = textColor
		UITableView.appearance().backgroundColor = backgroundColor
		UILabel.appearance().textColor = textColor
		UIView.appearance(whenContainedInInstancesOf: [UITableView.self]).backgroundColor = backgroundColor
		UIVisualEffectView.appearance().backgroundColor = backgroundColor
		NewMessageView.appearance().backgroundColor = newMessageBackground
		application.windows.reload()
	}
	
	func logThemeChanging() {
		print("Выбрана тема: \(themeName)")
	}
}

