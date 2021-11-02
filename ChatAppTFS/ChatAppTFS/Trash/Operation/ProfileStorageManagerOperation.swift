//
//  ProfileStorageManagerOperation.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

final class ProfileStorageManagerOperation: StoredLocally {
	
	static let shared = ProfileStorageManagerOperation()
	 
	private let queue = OperationQueue()
	
	private init() { }
	
	func saveLocally(_ plist: [String: Data], completion: @escaping ResultClosure<Bool>) {
		let saveDataOperation = LocalDataSaveOperation(with: save(_:forKey:completion:), plist: plist)
		saveDataOperation.qualityOfService = .utility
		saveDataOperation.completionBlock = {
			OperationQueue.main.addOperation {
				if let result = saveDataOperation.result {
					completion(result)
				} else {
					completion(.failure(LocalDataOperationError.failureSaving))
				}
			}
		}
		queue.addOperation(saveDataOperation)
	}
	
	func loadLocally(completion: @escaping ResultClosure<[String: Data]>) {
		let loadDataOperation = LocalDataLoadOperation(with: getPlist(completion:))
		loadDataOperation.qualityOfService = .utility
		loadDataOperation.completionBlock = {
			OperationQueue.main.addOperation {
				if let result = loadDataOperation.result {
					completion(result)
				} else {
					completion(.failure(LocalDataOperationError.failureLoading))
				}
			}
		}
		queue.addOperation(loadDataOperation)
	}
}
