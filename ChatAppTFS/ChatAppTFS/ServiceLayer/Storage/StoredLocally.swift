//
//  PlistManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

protocol StoredLocally: AnyObject {
	func save(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>)
	func load(completion: @escaping ResultClosure<[String: Data]>)
	func loadValue(for key: String, completion: @escaping ResultClosure<Data>)
}
