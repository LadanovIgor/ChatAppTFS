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

//extension UINavigationController {
//
//	func setStatusBar() {
//		let statusBarFrame: CGRect
//		if #available(iOS 13.0, *) {
//			statusBarFrame = navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
//		} else {
//			statusBarFrame = UIApplication.shared.statusBarFrame
//		}
//		let statusBarView = UIView()
//		statusBarView.backgroundColor = .green
//		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapped))
//		statusBarView.addGestureRecognizer(gesture)
//		statusBarView.frame = statusBarFrame
//		view.addSubview(statusBarView)
//	}
//	
//	@objc private func didTapped() {
//		print("tapped")
//	}
//
//}
