//
//  CustomOperations.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 20.10.2021.
//

import Foundation

final class LocalDataLoadOperation: Operation {

	var result: Result<[String: Data], Error>?
	var task: (ResultClosure<[String: Data]>) -> Void
	
	init(with task: @escaping (ResultClosure<[String: Data]>) -> Void) {
		self.task = task
		super.init()
	}

	override func main() {
		if isCancelled { return }
		task { [weak self] result in
			self?.result = result
		}
	}
}

final class LocalDataSaveOperation: Operation {
	
	var task: (Data?, String, (StoredLocallyError?) -> ()) -> Void
	var error: Error?

	private let plist: [String: Data]

	init(with task: @escaping (Data?, String, (StoredLocallyError?) -> ()) -> Void, plist: [String: Data]) {
		self.plist = plist
		self.task = task
		super.init()
	}

	override func main() {
		if isCancelled { return }
		for key in plist.keys {
			if isCancelled { return }
			task(plist[key], key) { [weak self] error in
				self?.error = error
			}
		}
	}
}

