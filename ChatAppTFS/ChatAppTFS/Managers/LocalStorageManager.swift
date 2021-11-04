//
//  ProfileStorageManagerGCD.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

final class LocalStorageManager: StoredLocally {
	
	static let shared = LocalStorageManager()
	
	private let queue = DispatchQueue.global(qos: .utility)
	
	private init() { }
	
	func saveLocally(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>) {
		queue.async { [weak self] in
			self?.savePlist(plist) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
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
			self?.getValue(for: Constants.LocalStorage.themeKey) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
}
