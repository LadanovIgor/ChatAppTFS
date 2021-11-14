//
//  ProfileStorageManagerGCD.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

final class LocalStorageService: StoredLocally {
	
	private let queue = DispatchQueue.global(qos: .utility)
	
	// MARK: - Public
	
	public func saveLocally(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>) {
		queue.async { [weak self] in
			self?.savePlist(plist) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
	
	public func loadLocally(completion: @escaping ResultClosure<[String: Data]>) {
		queue.async { [weak self] in
			self?.getPlist { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}

	public func loadData(for key: String, completion: @escaping ResultClosure<Data>) {
		queue.async { [weak self] in
			self?.getValue(for: key) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
}
