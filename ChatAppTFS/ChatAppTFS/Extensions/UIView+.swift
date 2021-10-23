//
//  UIView+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import UIKit

extension UIView {
	func round() {
		self.layer.cornerRadius = self.frame.height / 2
	}
}

extension UIView {
	func addSubViews(_ views: UIView...) {
		views.forEach { addSubview($0) }
	}
}
