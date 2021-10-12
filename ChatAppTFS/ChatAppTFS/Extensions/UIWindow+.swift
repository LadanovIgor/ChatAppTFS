//
//  UIWindow+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 12.10.2021.
//

import UIKit

extension UIWindow {
	func reload() {
		subviews.forEach { view in
			view.removeFromSuperview()
			addSubview(view)
		}
	}
}

extension Array where Element == UIWindow {
	func reload() {
		forEach { $0.reload() }
	}
}
