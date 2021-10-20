//
//  ProfileStorageManagerOperation.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

class ProfileStorageManagerOperation {
	
	static let shared = ProfileStorageManagerOperation()
	 
	private let queue = OperationQueue()
	
	private init() { }
	
	func saveLocally(_ plist: [String: Data], completion: @escaping (Error?) -> Void) {
		let saveDataOperation = LocalDataSaveOperation(plist: plist)
		saveDataOperation.completionBlock = {
			OperationQueue.main.addOperation {
				completion(saveDataOperation.error)
			}
		}
		queue.addOperation(saveDataOperation)
	}
	
	func loadLocally(completion: @escaping (Result<[String: Data], Error>) -> Void) {
		let loadDataOperation = LocalDataLoadOperation()
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
