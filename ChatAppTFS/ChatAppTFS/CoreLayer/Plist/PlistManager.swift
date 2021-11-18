//
//  PlistManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 18.11.2021.
//

import Foundation

final class PlistManager {

	// MARK: - Private
	
	private var sourcePath: String? {
		guard let path = Bundle.main.path(forResource: Constants.LocalStorage.plistFileName, ofType: "plist") else { return nil }
		return path
	}
	
	private var fileURL: URL? {
		guard sourcePath != nil else { return nil }
		let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		return directory?.appendingPathComponent("\(Constants.LocalStorage.plistFileName).plist")
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
	
	private func save(_ data: Data?, forKey key: String, completion: ResultClosure<Bool>) {
		guard var dict = getValueInPlistFile() else {
			completion(.failure(StoredLocallyError.fileUnavailable))
			return
		}
		guard let data = data else {
			completion(.failure(StoredLocallyError.invalidData))
			return
		}
		dict[key] = data
		do {
			try addValuesToPlistFile(dictionary: dict)
			completion(.success(true))
		} catch {
			completion(.failure(StoredLocallyError.couldNotSaveData))
		}
	}
	
	// MARK: - Public
	
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

	// MARK: - PlistManagerProtocol

extension PlistManager: PlistManagerProtocol {
	public func save(_ plist: [String: Data], completion: ResultClosure<Bool>) {
		for key in plist.keys {
			save(plist[key], forKey: key) { result in
				switch result {
				case .failure(let error):
					completion(.failure(error))
					return
				default: break
				}
			}
		}
		completion(.success(true))
	}

	public func getPlist(completion: ResultClosure<[String: Data]>) {
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
	
	public func getValue(for key: String, completion: @escaping ResultClosure<Data>) {
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
