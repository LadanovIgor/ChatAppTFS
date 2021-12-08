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
		let promise = XCTestExpectation()
		var catchError: Error?
		storageService.loadValue(for: key) { result in
			switch result {
			case .success: break
			case .failure(let error):
				catchError = error
				promise.fulfill()
			}
		}
		wait(for: [promise], timeout: 1)
		XCTAssertEqual(key, mockPlistManager.key)
		XCTAssertTrue(catchError is MockError)
	}
	
	func testFailureSavePlist() {
		let promise = XCTestExpectation()
		let plist: [String: Data] = ["Foo": Data()]
		var catchError: Error?
		storageService.save(plist) { result in
			switch result {
			case .success: break
			case .failure(let error):
				catchError = error
				promise.fulfill()
			}
		}
		wait(for: [promise], timeout: 1)
		XCTAssertEqual(plist, mockPlistManager.plist)
		XCTAssertTrue(catchError is MockError)
	}
	
	func testFailureLoadPlist() {
		let promise = XCTestExpectation()
		var catchError: Error?
		storageService.load { result in
			switch result {
			case .success: break
			case .failure(let error):
				catchError = error
				promise.fulfill()
			}
		}
		wait(for: [promise], timeout: 1)
		XCTAssertTrue(catchError is MockError)
	}
}
