//
//  ProfileStorageManagerGCD.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

final class StorageService: StoredLocally {
	
	private let queue = DispatchQueue.global(qos: .utility)
	private var plistManager: PlistManagerProtocol
	
	// MARK: - Init
	
	init(plistManager: PlistManagerProtocol) {
		self.plistManager = plistManager
	}
	
	// MARK: - Public
	
	public func save(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>) {
		queue.async { [weak self] in
			self?.plistManager.save(plist) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
	
	public func load(completion: @escaping ResultClosure<[String: Data]>) {
		queue.async { [weak self] in
			self?.plistManager.getPlist { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}

	public func loadValue(for key: String, completion: @escaping ResultClosure<Data>) {
		queue.async { [weak self] in
			self?.plistManager.getValue(for: key) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
	
	public func loadThemeFor(application: UIApplication) {
		loadValue(for: Constants.LocalStorage.themeKey) { result in
			switch result {
			case .success(let data):
				data.setTheme(for: application)
			case .failure:
				LightTheme().apply(for: application)
			}
		}
	}
}
