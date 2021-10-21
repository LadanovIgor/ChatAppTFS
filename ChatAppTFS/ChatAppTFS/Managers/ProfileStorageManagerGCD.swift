//
//  ProfileStorageManagerGCD.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

class ProfileStorageManagerGCD: StoredLocally {
	
	static let shared = ProfileStorageManagerGCD()
	
	private let queue = DispatchQueue.global(qos: .utility)
	
	private init() { }
	
	func saveLocally(_ plist: [String: Data], completion: @escaping (Error?) -> Void) {
		queue.async { [weak self] in
			for key in plist.keys {
				self?.save(plist[key], forKey: key) { error in
					DispatchQueue.main.async {
						completion(error)
					}
				}
			}
		}
	}
	
	func loadLocally(completion: @escaping (Result<[String: Data], Error>) -> Void) {
		queue.async { [weak self] in
			self?.getPlist { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
	
	func loadTheme(completion: @escaping (Result<Data, Error>) -> Void) {
		queue.async { [weak self] in
			self?.getValue(for: Constants.PlistManager.themeKey) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
}
