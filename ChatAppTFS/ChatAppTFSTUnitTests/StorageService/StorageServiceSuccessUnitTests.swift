//
//  StorageServiceUnitTests.swift
//  ChatAppTFSTUnitTests
//
//  Created by Ladanov Igor on 07.12.2021.
//

import XCTest
@testable import ChatAppTFS

class StorageServiceSuccessUnitTests: XCTestCase {
	
	var storageService: StorageService!
	var mockPlistManager = MockPlistManagerSuccess()

    override func setUpWithError() throws {
		try super.setUpWithError()
		storageService = StorageService(plistManager: mockPlistManager)
	}

    override func tearDownWithError() throws {
		try super.tearDownWithError()
		storageService = nil
	}
	
	func testSuccessLoadValue() {
		let key = "Foo"
		storageService.loadValue(for: key) { [weak self] result in
			switch result {
			case .success(let data):
				XCTAssertEqual(key, self?.mockPlistManager.key)
				XCTAssertEqual(data, Data())
			case .failure: break
			}
		}
	}
	
	func testSuccessSavePlist() {
		let plist: [String: Data] = ["Foo": Data()]
		storageService.save(plist) { [weak self] result in
			switch result {
			case .success(let success):
				XCTAssertEqual(plist, self?.mockPlistManager.plist)
				XCTAssertTrue(success)
			case .failure: break
			}
		}
	}
	
	func testSuccessLoadPlist() {
		storageService.load { result in
			switch result {
			case .success(let plist):
				XCTAssertEqual(plist, ["Foo": Data()])
			case .failure: break
			}
		}
	}
}
