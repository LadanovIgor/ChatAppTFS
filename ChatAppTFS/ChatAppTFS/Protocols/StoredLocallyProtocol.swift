//
//  PlistManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

protocol StoredLocally: AnyObject {
	func save(_ data: Data?, forKey key: String, completion: (StoredLocallyError?) -> Void)
	func getPlist(completion: @escaping ResultClosure<[String: Data]>)
	func getValue(for key: String, completion: @escaping ResultClosure<Data>)
	func saveLocally(_ plist: [String: Data], completion: @escaping (Error?) -> Void)
	func loadLocally(completion: @escaping ResultClosure<[String: Data]>)
}

extension StoredLocally {
	
	private var sourcePath: String? {
		guard let path = Bundle.main.path(forResource: Constants.PlistManager.plistFileName, ofType: "plist") else { return nil }
		return path
	}
	
	private var fileURL: URL? {
		guard sourcePath != nil else { return nil }
		let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		return directory?.appendingPathComponent("\(Constants.PlistManager.plistFileName).plist")
	}
	
	private func addValuesToPlistFile(dictionary: [String: Data]) throws {
		guard let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
			return
		}
		guard let plistData = try? PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0) else {
			throw StoredLocallyError.invalidData
		}
		do {
			try plistData.write(to: fileURL)
		} catch {
			throw StoredLocallyError.fileNotWritten
		}
	}
	
	private func getValueInPlistFile() -> [String: Data]? {
		guard let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path), let data = try? Data(contentsOf: fileURL),
			  let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Data] else {
				  return nil
			  }
		return plist
	}
	
	func save(_ data: Data?, forKey key: String, completion: (StoredLocallyError?) -> Void) {
		guard var dict = getValueInPlistFile() else {
			completion(.fileUnavailable)
			return
		}
		guard let data = data else {
			completion(.invalidData)
			return
		}
		dict[key] = data
		do {
			try addValuesToPlistFile(dictionary: dict)
			completion(nil)
		} catch {
			completion(.couldNotSaveData)
		}
	}
	
	func getPlist(completion: ResultClosure<[String: Data]>) {
		guard let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
			completion(.failure(StoredLocallyError.fileDoesNotExist))
			return
		}
		guard let data = try? Data(contentsOf: fileURL),
			  let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Data] else {
			completion(.failure(StoredLocallyError.couldNotGetData))
			return
		}
		completion(.success(plist))
	}
	
	func getValue(for key: String, completion: @escaping ResultClosure<Data>) {
		guard let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
			completion(.failure(StoredLocallyError.fileDoesNotExist))
			return
		}
		guard let dict = getValueInPlistFile() else {
			completion(.failure(StoredLocallyError.fileUnavailable))
			return
		}
		guard let value = dict[key] else {
			completion(.failure(StoredLocallyError.keyValuePairDoesNotExist))
			return
		}
		completion(.success(value))
	}
}
