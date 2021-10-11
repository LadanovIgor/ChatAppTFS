//
//  ThemeViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

import UIKit

class ThemeViewController: UIViewController {

	@IBOutlet weak var champagneThemeButton: UIButton!
	@IBOutlet weak var darkThemeButton: UIButton!
	@IBOutlet weak var lightThemeButton: UIButton!
	@IBOutlet weak var closeButton: UIButton!
	
	var themeChanged: ((UIColor) -> Void)?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		decorateButtons()
		addTargets()
    }

	private func decorateButtons() {
		champagneThemeButton.layer.cornerRadius = 14.0
		lightThemeButton.layer.cornerRadius = 14.0
		darkThemeButton.layer.cornerRadius = 14.0
	}
	
	private func addTargets() {
		closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
		lightThemeButton.addTarget(self, action: #selector(didTapThemeButton), for: .touchUpInside)
		darkThemeButton.addTarget(self, action: #selector(didTapThemeButton), for: .touchUpInside)
		champagneThemeButton.addTarget(self, action: #selector(didTapThemeButton), for: .touchUpInside)
	}
	
	@objc private func didTapCloseButton() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapThemeButton(_ button: UIButton) {
		themeChanged?(UIColor.red)
	}

}
