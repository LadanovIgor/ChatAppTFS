//
//  RouterUnitTests.swift
//  ChatAppTFSTUnitTests
//
//  Created by Ladanov Igor on 07.12.2021.
//

import XCTest
@testable import ChatAppTFS

class StorageServiceFailureUnitTests: XCTestCase {
	
	var storageService: StorageService!
	var mockPlistManager = MockPlistManagerFailure()

	override func setUpWithError() throws {
		try super.setUpWithError()
		storageService = StorageService(plistManager: mockPlistManager)
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		storageService = nil
	}
	
	func testFailureLoadValue() {
		let key = "Foo"
		storageService.loadValue(for: key) { [weak self] result in
			switch result {
			case .success: break
			case .failure(let error):
				XCTAssertEqual(key, self?.mockPlistManager.key)
				XCTAssertTrue(error is MockError)
			}
		}
	}
	
	func testFailureSavePlist() {
		let plist: [String: Data] = ["Foo": Data()]
		storageService.save(plist) { [weak self] result in
			switch result {
			case .success: break
			case .failure(let error):
				XCTAssertEqual(plist, self?.mockPlistManager.plist)
				XCTAssertTrue(error is MockError)
			}
		}
	}
	
	func testFailureLoadPlist() {
		storageService.load { result in
			switch result {
			case .success: break
			case .failure(let error):
				XCTAssertTrue(error is MockError)
			}
		}
	}
}
