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
	var backgroundColor: UIColor = UIColor(hex: 0x353839)
	var textColor: UIColor = .white
	var barStyle: UIBarStyle = .black
	var secondaryBackground: UIColor = UIColor(hex: 0x3F4243)
}
