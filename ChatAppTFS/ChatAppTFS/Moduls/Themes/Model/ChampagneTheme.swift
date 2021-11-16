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
	var backgroundColor: UIColor = UIColor(red: 238 / 255, green: 232 / 255, blue: 170 / 255, alpha: 1.0)
	var textColor: UIColor = UIColor(red: 75 / 255, green: 0 / 255, blue: 130 / 255, alpha: 1.0)
	var barStyle: UIBarStyle = .default
	var secondaryBackground: UIColor = UIColor(red: 250 / 255, green: 231 / 255, blue: 181 / 255, alpha: 1.0)
}
