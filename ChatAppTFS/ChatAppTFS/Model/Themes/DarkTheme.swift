//
//  DarkTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

struct DarkTheme: ThemeProtocol {
	static let name = String(describing: Self.self)
	var tint: UIColor = .white
	var backgroundColor: UIColor = .darkGray
	var textColor: UIColor = .white
	var barStyle: UIBarStyle = .black
	var secondaryBackground: UIColor = UIColor(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1.0)
}
