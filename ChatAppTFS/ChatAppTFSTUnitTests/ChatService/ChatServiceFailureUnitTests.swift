//
//  RouterMockDependencies.swift
//  ChatAppTFSTUnitTests
//
//  Created by Ladanov Igor on 07.12.2021.
//

import XCTest
@testable import ChatAppTFS

class ChatServiceFailureUnitTests: XCTestCase {
	
	var chatService: ChatService!
	var mockCoreDataManager: MockCoreDataManager!
	var mockFireStoreManager: MockFirestoreManagerFailure!

	override func setUpWithError() throws {
		try super.setUpWithError()
		mockCoreDataManager = MockCoreDataManager()
		mockFireStoreManager = MockFirestoreManagerFailure()
		chatService = ChatService(coreDataManager: mockCoreDataManager, firestoreManager: mockFireStoreManager)
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		mockCoreDataManager = nil
		mockFireStoreManager = nil
		chatService = nil
	}
	
	func testFailureGetChannelsFromFirestore() {
        mockFireStoreManager.error = MockError.error
        var catchError: Error?
        let promis = XCTestExpectation()
        
		chatService.startFetchingChannels()
		mockFireStoreManager.getChannels { result in
			switch result {
			case .success: break
			case .failure(let error):
				catchError = error
                promis.fulfill()
			}
		}
        
        wait(for: [promis], timeout: 1.0)
        XCTAssertTrue(catchError is MockError)
        
	}

	func testFailureGetMessagesFromFirestore() throws {
		let channelId = "Foo"
        var catchError: Error?
        let promis = XCTestExpectation()

		chatService.startFetchingMessages(from: channelId)
		mockFireStoreManager.getMessages(from: channelId) { result in
			switch result {
			case .success: break
			case .failure(let error):
				catchError = error
                promis.fulfill()
			}
		}
        
        wait(for: [promis], timeout: 1.0)
        XCTAssertTrue(catchError is MockError)
	}
	
}
