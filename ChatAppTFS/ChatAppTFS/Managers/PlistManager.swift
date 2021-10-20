//
//  PlistManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

final class PlistManager {
	
	public static let shared = PlistManager()
	
	private init() { }
	
	let name = Constants.PlistManager.plistFileName
	
	private let fileManager = FileManager.default
	
	private var sourcePath: String? {
		guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return nil }
		return path
	}
	
	private var fileURL: URL? {
		guard sourcePath != nil else { return nil }
		let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		return directory?.appendingPathComponent("\(name).plist")
	}
	
	private func addValuesToPlistFile(dictionary: [String: Data]) throws {
		guard let fileURL = fileURL, fileManager.fileExists(atPath: fileURL.path) else {
			return
		}
		guard let plistData = try? PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0) else {
			throw PlistManagerError.invalidData
		}
		do {
			try plistData.write(to: fileURL)
		}
		catch {
			throw PlistManagerError.fileNotWritten
		}
	}
	
	private func getValueInPlistFile() -> [String: Data]? {
		if let fileURL = fileURL, fileManager.fileExists(atPath: fileURL.path) {
			guard let data = try? Data(contentsOf: fileURL)  else {
				return nil
			}
			guard let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String:Data] else {
				return nil
			}
			return plist
		} else {
			return nil
		}
	}
	
	func start() {
		guard let source = sourcePath, let fileURL = fileURL, fileManager.fileExists(atPath: source) else {
			return
		}
		if !fileManager.fileExists(atPath: fileURL.path) {
			do {
				try fileManager.copyItem(atPath: source, toPath: fileURL.path)
			} catch {
				print(error.localizedDescription)
				return
			}
		}
	}
	
	func save(_ data: Data?, forKey key: String, completion:(PlistManagerError?) -> ()) {
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
		}
		catch {
			completion(error as? PlistManagerError)
		}
	}
	
	func getPlist(completion: @escaping (Result<[String: Data], Error>) -> Void) {
		guard let fileURL = fileURL, fileManager.fileExists(atPath: fileURL.path) else {
			completion(.failure(PlistManagerError.fileDoesNotExist))
			return
		}
		guard let data = try? Data(contentsOf: fileURL),
			  let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String:Data] else {
			completion(.failure(PlistManagerError.couldNotGetData))
			return
		}
		completion(.success(plist))
	}
}

