//
//  ThemePresenter.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation

class ThemePresenter {

	private var router: RouterProtocol?
	private weak var view: ThemeViewProtocol?
	
	var themeSelected: ThemeClosure?
	
	init(router: RouterProtocol) {
		self.router = router
	}
	
	public func set(view: ThemeViewProtocol) {
		self.view = view
	}
}

// MARK: - ThemePresenterProtocol

extension ThemePresenter: ThemePresenterProtocol {
	public func close() {
		router?.dismiss(view)
	}
	
	public func lightThemeSelected() {
		themeSelected?(LightTheme())
		close()
	}
	
	public func darkThemeSelected() {
		themeSelected?(DarkTheme())
		close()
	}
	
	public func champagneThemeSelected() {
		themeSelected?(ChampagneTheme())
		close()
	}
}
