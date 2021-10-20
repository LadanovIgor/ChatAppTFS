//
//  Data+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 20.10.2021.
//

import UIKit

extension Data {
	func setTheme(for application: UIApplication) {
		guard let themeName = String(data: self, encoding: .utf8) else {
			LightTheme().apply(for: application)
			return
		}
		if themeName == String(describing: DarkTheme.self) {
			DarkTheme().apply(for: application)
		} else if themeName == String(describing: ChampagneTheme.self) {
			ChampagneTheme().apply(for: application)
		} else {
			LightTheme().apply(for: application)
		}
	}
}
