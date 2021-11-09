//
//  ThemeViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

import UIKit

class ThemeViewController: UIViewController {
	
	// MARK: - Outlets and Properties

	@IBOutlet private weak var champagneThemeButton: AppButton!
	@IBOutlet private weak var darkThemeButton: AppButton!
	@IBOutlet private weak var lightThemeButton: AppButton!
	@IBOutlet private weak var closeButton: UIButton!
	
	var themeSelected: ThemeClosure?
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		decorateButtons()
		addTargets()
    }
	
	// MARK: - Private

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
		themeSelected?(LightTheme())
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapChampagneThemeButton() {
		themeSelected?(ChampagneTheme())
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapDarkThemeButton(_ button: UIButton) {
		themeSelected?(DarkTheme())
		dismiss(animated: true, completion: nil)
	}

}
