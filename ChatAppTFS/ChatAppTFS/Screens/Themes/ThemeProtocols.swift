//
//  ThemeProtocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation

protocol ThemePresenterProtocol: AnyObject {
	func close()
	func lightThemeSelected()
	func darkThemeSelected()
	func champagneThemeSelected()
}

protocol ThemeViewProtocol: AnyObject {
	
}
