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
	
	func saveLocally(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>) {
		queue.async { [weak self] in
			self?.savePlist(plist) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
//			for key in plist.keys {
//				self?.save(plist[key], forKey: key) { result in
//					DispatchQueue.main.async {
//						completion(result)
//					}
//				}
//			}
		}
	}
	
	func loadLocally(completion: @escaping ResultClosure<[String: Data]>) {
		queue.async { [weak self] in
			self?.getPlist { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
	
	func loadTheme(completion: @escaping ResultClosure<Data>) {
		queue.async { [weak self] in
			self?.getValue(for: Constants.PlistManager.themeKey) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
}
