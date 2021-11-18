//
//  ProfileStorageManagerGCD.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

final class StorageService: StoredLocally {
	
	private let queue = DispatchQueue.global(qos: .utility)
	
	// MARK: - Public
	
	public func save(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>) {
		queue.async { [weak self] in
			self?.savePlist(plist) { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}
	
	public func load(completion: @escaping ResultClosure<[String: Data]>) {
		queue.async { [weak self] in
			self?.getPlist { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}
		}
	}

	public func loadValue(for key: String, completion: @escaping ResultClosure<Data>) {
		queue.async { [weak self] in
			self?.getValue(for: key) { result in
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
	
	public func createFileLocallyIfNeeded() {
		guard let sourcePath = Bundle.main.path(forResource: Constants.LocalStorage.plistFileName, ofType: "plist"),
			  let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
			  FileManager.default.fileExists(atPath: sourcePath) else { return }
		let fileURL = directory.appendingPathComponent("\(Constants.LocalStorage.plistFileName).plist")
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			try? FileManager.default.copyItem(atPath: sourcePath, toPath: fileURL.path)
		}
	}
}
