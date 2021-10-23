//
//  CircleImageView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class CircleImageView: UIImageView {

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
		return pow(center.x - point.x, 2) + pow(center.y - point.y, 2) <= pow(bounds.size.width / 2, 2)
	}
}
