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
			LightTheme().apply(for: application, with: false)
			return
		}
		switch themeName {
		case DarkTheme.name: DarkTheme().apply(for: application, with: false)
		case ChampagneTheme.name: ChampagneTheme().apply(for: application, with: false)
		default: LightTheme().apply(for: application, with: false)
		}
		
	}
}
