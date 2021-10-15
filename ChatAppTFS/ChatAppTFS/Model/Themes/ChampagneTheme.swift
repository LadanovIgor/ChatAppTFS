//
//  ChampagneTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

struct ChampagneTheme: ThemeProtocol {
	var themeName: String = "Champagne"
	var tint: UIColor = .purple
	var backgroundColor: UIColor = UIColor.init(red: 0.969, green: 0.906, blue: 0.598, alpha: 1.0)
	var textColor: UIColor = .purple
	var barStyle: UIBarStyle = .default
	var newMessageBackground: UIColor = UIColor.init(red: 1, green: 1, blue: 122/255, alpha: 1.0)
}
