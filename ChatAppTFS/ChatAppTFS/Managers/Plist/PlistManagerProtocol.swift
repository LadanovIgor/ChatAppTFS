//
//  PlistManagerProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 18.11.2021.
//

import Foundation

protocol PlistManagerProtocol: AnyObject {
	func save(_ plist: [String: Data], completion: ResultClosure<Bool>)
	func getPlist(completion: ResultClosure<[String: Data]>)
	func getValue(for key: String, completion: @escaping ResultClosure<Data>)
}
