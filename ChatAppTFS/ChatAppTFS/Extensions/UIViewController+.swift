//
//  UIViewController+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import UIKit

extension UIViewController {
	func presentAlert(title: String?, message: String?, actions: [UIAlertAction], completion: (() -> Void)? = nil
	) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach { alert.addAction($0) }
		present(alert, animated: true, completion: completion)
	}
}
