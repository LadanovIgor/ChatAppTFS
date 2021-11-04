//
//  NSLayoutConstraint.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import UIKit

extension NSLayoutConstraint {
	
	static func constraints(withNewVisualFormat vf: String, metrics: [String: Any]?, views: [String: Any]) -> [NSLayoutConstraint] {
		let  separatedArray = vf.split(separator: ",")
		switch separatedArray.count {
		case 1: return NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[0])", options: [], metrics: metrics, views: views)
		case 2: return NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[0])",
														  options: [],
														  metrics: metrics,
														  views: views)
				+ NSLayoutConstraint.constraints(
					withVisualFormat: "\(separatedArray[1])",
					options: [],
					metrics: metrics,
					views: views)
		default: return NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[0])", options: [], metrics: metrics, views: views)
		}
	}
}
