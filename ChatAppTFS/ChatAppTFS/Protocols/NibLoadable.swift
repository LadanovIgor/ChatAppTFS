//
//  NibLoadable.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

protocol NibLoadable: AnyObject {
	static var nib: UINib { get }
}

extension NibLoadable {
	static var nib: UINib {
		return UINib(nibName: name, bundle: Bundle.init(for: self))
	}
	static var name: String {
		return String(describing: self)
	}
}
