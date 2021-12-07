//
//  ChatAppTFSTUnitTests.swift
//  ChatAppTFSTUnitTests
//
//  Created by Ladanov Igor on 07.12.2021.
//

import XCTest
@testable import ChatAppTFS

class ChatServiceSuccessUnitTests: XCTestCase {
	
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
	
	func testSuccessGetChannelsFromFirestore() {
		chatService.startFetchingChannels()
		var catchChannels = [Channel]()
		mockFireStoreManager.getChannels { result in
			switch result {
			case .success(let channels):
				catchChannels = channels
			case .failure: break
			}
		}
		XCTAssertTrue(mockFireStoreManager.isChannelsListening)
		XCTAssertEqual(catchChannels.count, 1)
		XCTAssertEqual(catchChannels[0].id, "Baz")
	}

    func testSuccessGetMessagesFromFirestore() throws {
		let channelId = "Foo"
		chatService.startFetchingMessages(from: channelId)
		var catchMessages = [Message]()
		mockFireStoreManager.getMessages(from: channelId) { result in
			switch result {
			case .success(let messages): catchMessages = messages
			case .failure: break
			}
		}
		XCTAssertEqual(mockFireStoreManager.channelId, channelId)
		XCTAssertTrue(mockFireStoreManager.isMessagesListening)
		XCTAssertEqual(catchMessages.count, 1)
		XCTAssertEqual(catchMessages[0].content, "Foo")
    }
	
	func testStopFetchingChannels() {
		chatService.stopFetchingChannels()
		XCTAssertFalse(mockFireStoreManager.isChannelsListening)
	}
	
	func testStopFetchingMessages() {
		chatService.stopFetchingMessages()
		XCTAssertFalse(mockFireStoreManager.isMessagesListening)
	}
	
	func testDeleteChannel() {
		let channelId = "Foo"
		chatService.deleteChannel(with: channelId)
		XCTAssertEqual(channelId, mockFireStoreManager.deleteChannelId)
	}
	
	func testAddMessage() {
		let content = "Bar Baz"
		
		chatService.addMessage(with: content, senderId: "Foo")
		XCTAssertEqual(content, mockFireStoreManager.content)
		XCTAssertEqual("Foo", mockFireStoreManager.senderId)
	}
	
	func testAddChannel() {
		let name = "Foo"
		chatService.addChannel(with: name)
		XCTAssertEqual(name, mockFireStoreManager.name)
	}
}
