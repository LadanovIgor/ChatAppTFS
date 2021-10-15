//
//  UITableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//
import UIKit

extension UITableViewCell {
	func removeBottomSeparator() {
		for view in self.subviews where String(describing: type(of: view)).hasSuffix("SeparatorView") {
			view.removeFromSuperview()
		}

	}
}

