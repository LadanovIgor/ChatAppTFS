//
//  LightTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

struct LightTheme: ThemeProtocol {
	static let name = String(describing: Self.self)
	var tint: UIColor = .black
	var backgroundColor: UIColor = UIColor(red: 254 / 255, green: 254 / 255, blue: 250 / 255, alpha: 1.0)
	var textColor: UIColor = .black
	var barStyle: UIBarStyle = .default
	var secondaryBackground: UIColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1.0)
}
