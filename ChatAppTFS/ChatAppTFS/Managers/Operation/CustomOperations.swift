//
//  CustomOperations.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 20.10.2021.
//

import Foundation

final class LocalDataLoadOperation: Operation {

	var result: Result<[String: Data], Error>?

	override func main() {
		if isCancelled { return }
		PlistManager.shared.getPlist { [weak self] result in
			self?.result = result
		}
	}
}

final class LocalDataSaveOperation: Operation {

	var error: Error?

	private let plist: [String: Data]

	init(plist: [String: Data]) {
		self.plist = plist
		super.init()
	}

	override func main() {
		if isCancelled { return }
		for key in plist.keys {
			if isCancelled { return }
			PlistManager.shared.save(plist[key], forKey: key) { [weak self] error in
				self?.error = error
			}
		}
	}
}

