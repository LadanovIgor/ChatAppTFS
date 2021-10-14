//
//  DarkTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

struct DarkTheme: ThemeProtocol {
	var themeName: String = "Dark"
	var tint: UIColor = .white
	var backgroundColor: UIColor = .darkGray
	var textColor: UIColor = .white
	var barStyle: UIBarStyle = .black
	var newMessageBackground: UIColor = .gray
}
