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

extension UIViewController {
//	var emitterLayer: CAEmitterLayer {
//		return CAEmitterLayer()
//	}
//	
//	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//		super.touchesBegan(touches, with: event)
//		guard let touch = touches.first else {
//			return
//		}
//		startTouchAnimate(with: touch.location(in: view))
//		view.layer.addSublayer(emitterLayer)
//	}
//	
//	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//		super.touchesEnded(touches, with: event)
//		stopTouchAnimate()
//	}
}
