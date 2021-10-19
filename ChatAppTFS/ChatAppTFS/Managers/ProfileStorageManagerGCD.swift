//
//  ProfileStorageManagerGCD.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

class ProfileStorageManagerGCD {
	
	static let shared = ProfileStorageManagerGCD()
	
	private let queue = DispatchQueue.global(qos: .utility)
	
	private init() { }
	
//	func saveLocally(_ plist: [String: String], completion: @escaping CompletionClosure<Bool>) {
//		queue.async {
//
//		}
//	}
//
//	func loadLocally(completion: @escaping CompletionClosure<[String: String]>) {
//		queue.async {
//
//		}
//	}
//}
}
