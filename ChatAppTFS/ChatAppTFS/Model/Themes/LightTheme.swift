//
//  LightTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

struct LightTheme: ThemeProtocol {
	var themeName: String = "Light"
	var tint: UIColor = .black
	var backgroundColor: UIColor = .white
	var textColor: UIColor = .black
	var barStyle: UIBarStyle = .default
	var newMessageBackground: UIColor = UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
}
