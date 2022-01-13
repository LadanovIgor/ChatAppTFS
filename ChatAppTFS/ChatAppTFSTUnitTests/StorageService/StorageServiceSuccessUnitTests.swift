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
		let promise = XCTestExpectation()
		var catchData: Data?
		storageService.loadValue(for: key) { result in
			switch result {
			case .success(let data):
				catchData = data
				promise.fulfill()
			case .failure: break
			}
		}
		wait(for: [promise], timeout: 1)
		XCTAssertEqual(key, mockPlistManager.key)
		XCTAssertEqual(catchData, Data())
	}
	
	func testSuccessSavePlist() {
		let promise = XCTestExpectation()
		let plist: [String: Data] = ["Foo": Data()]
		storageService.save(plist) { result in
			switch result {
			case .success:
				promise.fulfill()
			case .failure: break
			}
		}
		wait(for: [promise], timeout: 1)
		XCTAssertEqual(plist, mockPlistManager.plist)
	}
	
	func testSuccessLoadPlist() {
		let promise = XCTestExpectation()
		var catchPlist: [String: Data]?
        mockPlistManager.plist = ["Foo": Data()]
		storageService.load { result in
			switch result {
			case .success(let plist):
					catchPlist = plist
					promise.fulfill()

			case .failure: break
			}
		}
		wait(for: [promise], timeout: 1)
		XCTAssertEqual(catchPlist, ["Foo": Data()])
	}
}
