//
//  File.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import Foundation

protocol LifeCycleProtocol {
	func viewDidLoad()
	func viewWillAppear()
}

extension LifeCycleProtocol {
	func viewDidLoad() { }
	func viewWillAppear() { }
}
