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
	var backgroundColor: UIColor = .white
	var textColor: UIColor = .black
	var barStyle: UIBarStyle = .default
	var secondaryBackground: UIColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
}
