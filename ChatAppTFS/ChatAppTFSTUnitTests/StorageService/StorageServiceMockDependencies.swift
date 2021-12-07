//
//  StorageServiceMockDependencies.swift
//  ChatAppTFSTUnitTests
//
//  Created by Ladanov Igor on 07.12.2021.
//

@testable import ChatAppTFS

class MockPlistManagerSuccess: PlistManagerProtocol {
	
	var plist: [String: Data]?
	var key: String?
	
	func save(_ plist: [String: Data], completion: ResultClosure<Bool>) {
		self.plist = plist
		completion(.success(true))
	}
	
	func getPlist(completion: ResultClosure<[String: Data]>) {
		let dict = ["Foo": Data()]
		completion(.success(dict))
	}
	
	func getValue(for key: String, completion: @escaping ResultClosure<Data>) {
		self.key = key
		completion(.success(Data()))
	}
}

enum MockError: Error {
	case error
}

class MockPlistManagerFailure: PlistManagerProtocol {
	
	var plist: [String: Data]?
	var key: String?
	
	func save(_ plist: [String: Data], completion: ResultClosure<Bool>) {
		self.plist = plist
		completion(.failure(MockError.error))
	}
	
	func getPlist(completion: ResultClosure<[String: Data]>) {
		completion(.failure(MockError.error))
	}
	
	func getValue(for key: String, completion: @escaping ResultClosure<Data>) {
		self.key = key
		completion(.failure(MockError.error))
	}
}
