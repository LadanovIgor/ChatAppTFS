//
//  DarkTheme.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation
import UIKit

struct DarkTheme: ThemeProtocol {
	static let name = String(describing: Self.self)
	var tint: UIColor = .white
	var backgroundColor: UIColor = UIColor(red: 53 / 255, green: 56 / 255, blue: 57 / 255, alpha: 1.0)
	var textColor: UIColor = .white
	var barStyle: UIBarStyle = .black
	var secondaryBackground: UIColor = UIColor(red: 63 / 255, green: 66 / 255, blue: 67 / 255, alpha: 1.0)
}
