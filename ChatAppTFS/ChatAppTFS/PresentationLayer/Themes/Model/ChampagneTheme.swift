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
	var backgroundColor: UIColor = UIColor(hex: 0xEEE8AA)
	var textColor = UIColor(hex: 0x4B0082)
	var barStyle: UIBarStyle = .default
	var secondaryBackground = UIColor(hex: 0xFAE7B5)
}
