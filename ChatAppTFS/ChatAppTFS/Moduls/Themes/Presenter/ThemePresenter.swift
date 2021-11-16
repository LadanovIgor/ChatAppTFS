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
		router?.dismiss(view)
	}
	
	func lightThemeSelected() {
		themeSelected?(LightTheme())
		close()
	}
	
	func darkThemeSelected() {
		themeSelected?(DarkTheme())
		close()
	}
	
	func champagneThemeSelected() {
		themeSelected?(ChampagneTheme())
		close()
	}
}
