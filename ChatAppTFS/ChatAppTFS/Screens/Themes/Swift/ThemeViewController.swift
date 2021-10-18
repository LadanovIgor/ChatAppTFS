//
//  ThemeViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

import UIKit

class ThemeViewController: UIViewController {

	@IBOutlet private weak var champagneThemeButton: UIButton!
	@IBOutlet private weak var darkThemeButton: UIButton!
	@IBOutlet private weak var lightThemeButton: UIButton!
	@IBOutlet private weak var closeButton: UIButton!
	
	var lightThemeSelected: ThemeClosure<LightTheme>?
	var darkThemeSelected: ThemeClosure<DarkTheme>?
	var champagneThemeSelected: ThemeClosure<ChampagneTheme>?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		decorateButtons()
		addTargets()
    }

	private func decorateButtons() {
		champagneThemeButton.layer.cornerRadius = Constants.ThemeScreen.buttonCornerRadius
		lightThemeButton.layer.cornerRadius = Constants.ThemeScreen.buttonCornerRadius
		darkThemeButton.layer.cornerRadius = Constants.ThemeScreen.buttonCornerRadius
	}
	
	private func addTargets() {
		closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
		lightThemeButton.addTarget(self, action: #selector(didTapLightThemeButton), for: .touchUpInside)
		darkThemeButton.addTarget(self, action: #selector(didTapDarkThemeButton), for: .touchUpInside)
		champagneThemeButton.addTarget(self, action: #selector(didTapChampagneThemeButton), for: .touchUpInside)
	}
	
	@objc private func didTapCloseButton() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapLightThemeButton() {
		lightThemeSelected?(LightTheme())
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapChampagneThemeButton() {
		champagneThemeSelected?(ChampagneTheme())
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapDarkThemeButton(_ button: UIButton) {
		darkThemeSelected?(DarkTheme())
		dismiss(animated: true, completion: nil)
	}

}
