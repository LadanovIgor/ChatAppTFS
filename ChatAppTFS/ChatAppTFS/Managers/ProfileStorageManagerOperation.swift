//
//  ProfileStorageManagerOperation.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

//class ProfileStorageManagerOperation {
//	static let shared = ProfileStorageManagerOperation()
//	
//	private let queue = OperationQueue()
//
//	private init() { }
//	
//	func saveLocally(_ plist: [String: String], completion: @escaping (Error?) -> Void)) {
//		let saveDataOperation = LocalDataSaveOperation(plist: plist)
//		
//		saveDataOperation.completionBlock = {
//			OperationQueue.main.addOperation {
//				guard let result = saveDataOperation.result else {
//					completion(.failure(LocalStorageError.failureSavingData))
//					return
//				}
//				completion(result)
//			}
//		}
//		
//		queue.addOperation(saveDataOperation)
//	}
//	
//	func loadLocally(completion: @escaping (Result<[String: String], Error>) -> Void) {
//		let loadDataOperation = LocalDataLoadOperation()
//		
//		loadDataOperation.completionBlock = {
//			OperationQueue.main.addOperation {
//				if let result = loadDataOperation.result {
//					completion(result)
//				} else {
//					completion(.failure())
//				}
//			}
//		}
//		queue.addOperation(loadDataOperation)
//	}
//	
//}
//class LocalDataLoadOperation: Operation {
//	
//	var result: Result<[String: String], Error>?
//	
//	override func main() {
//		loadData { [weak self] result in
//			self?.result = result
//		}
//		
//	}
//}
//
//class LocalDataSaveOperation: Operation {
//	
//	var result: ((Error?) -> Void)?
//	
//	private let plist: [String: String]
//	
//	init(plist: [String: String]) {
//		self.plist = plist
//		super.init()
//	}
//	
//	override func main() {
//		saveData(plist) {[weak self] result in
//			self?.result = result
//		}
//	}
//}
//
//}
