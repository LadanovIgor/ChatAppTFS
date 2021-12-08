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
	var mockFireStoreManager: MockFirestoreManager!

	override func setUpWithError() throws {
		try super.setUpWithError()
		mockCoreDataManager = MockCoreDataManager()
		mockFireStoreManager = MockFirestoreManager()
		chatService = ChatService(coreDataManager: mockCoreDataManager, firestoreManager: mockFireStoreManager)
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		mockCoreDataManager = nil
		mockFireStoreManager = nil
		chatService = nil
	}
	
	func testFailureGetChannelsFromFirestore() {
		chatService.startFetchingChannels()
		mockFireStoreManager.getChannels { result in
			switch result {
			case .success: break
			case .failure(let error):
				XCTAssertTrue(error is MockError)
			}
		}
	}

	func testFailureGetMessagesFromFirestore() throws {
		let channelId = "Foo"
		chatService.startFetchingMessages(from: channelId)
		mockFireStoreManager.getMessages(from: channelId) { result in
			switch result {
			case .success: break
			case .failure(let error):
				XCTAssertTrue(error is MockError)
			}
		}
	}
	
}
