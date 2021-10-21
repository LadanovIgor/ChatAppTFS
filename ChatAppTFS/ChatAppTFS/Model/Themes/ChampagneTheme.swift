//
//  ChampagneTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

struct ChampagneTheme: ThemeProtocol {
	static let name = String(describing: Self.self)
	var tint: UIColor = .purple
	var backgroundColor: UIColor = UIColor.init(red: 0.969, green: 0.906, blue: 0.598, alpha: 1.0)
	var textColor: UIColor = .purple
	var barStyle: UIBarStyle = .default
	var secondaryBackground: UIColor = UIColor.init(red: 1, green: 0.930, blue: 0.640, alpha: 1.0)
}
