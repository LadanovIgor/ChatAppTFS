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
	var backgroundColor: UIColor = UIColor(hex: 0xFEFEFA)
	var textColor: UIColor = .black
	var barStyle: UIBarStyle = .default
	var secondaryBackground = UIColor(hex: 0xF5F5F5)
}
