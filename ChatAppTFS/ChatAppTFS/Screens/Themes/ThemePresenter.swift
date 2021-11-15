//
//  ThemePresenter.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation

class ThemePresenter: ThemePresenterProtocol {

	var router: RouterProtocol?
	weak var view: ThemeViewProtocol?
	
	var themeSelected: ThemeClosure?
	
	init(router: RouterProtocol) {
		self.router = router
	}
	
	func close() {
		guard let router = router, let viewController = view as? UIViewController else {
			return
		}
		router.dismiss(viewController)
	}
	
	func lightThemeSelected() {
		themeSelected?(LightTheme())
	}
	
	func darkThemeSelected() {
		themeSelected?(DarkTheme())
	}
	
	func champagneThemeSelected() {
		themeSelected?(ChampagneTheme())
	}
}
