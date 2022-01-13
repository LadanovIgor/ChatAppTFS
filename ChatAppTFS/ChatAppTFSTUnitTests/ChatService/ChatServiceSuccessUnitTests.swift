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
	var mockDatabaseUpdater: MockDatabaseUpdater!

    override func setUpWithError() throws {
		try super.setUpWithError()
		mockCoreDataManager = MockCoreDataManager()
		mockFireStoreManager = MockFirestoreManager()
		mockDatabaseUpdater = MockDatabaseUpdater()
		chatService = ChatService(coreDataManager: mockCoreDataManager, firestoreManager: mockFireStoreManager)
		chatService.databaseUpdater = mockDatabaseUpdater
	}

    override func tearDownWithError() throws {
		try super.tearDownWithError()
        mockCoreDataManager = nil
		mockFireStoreManager = nil
		mockDatabaseUpdater = nil
		chatService = nil
    }
	
	func testSuccessGettingChannelsAndStorageToDatabase() {
		mockDatabaseUpdater.updateCalled = false
        var catchChannels = [Channel]()
        mockFireStoreManager.channels = [Channel(identifier: "Baz", name: "Bar", lastMessage: nil, lastActivity: nil)]
        
		chatService.startFetchingChannels()
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
		
		XCTAssertEqual(mockCoreDataManager.channels.count, 1)
		XCTAssertEqual(mockCoreDataManager.channels[0].id, "Baz")
		
		XCTAssertTrue(mockDatabaseUpdater.updateCalled)
	}

    func testSuccessGettingMessagesAndStorageToDatabase() throws {
		let channelId = "Foo"
		var catchMessages = [Message]()
		mockDatabaseUpdater.updateCalled = false
        mockFireStoreManager.messages = [Message(content: "Foo", created: nil, senderId: nil, senderName: nil)]
        
		chatService.startFetchingMessages(from: channelId)
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
		
		XCTAssertEqual(mockCoreDataManager.channelId, channelId)
		XCTAssertEqual(mockCoreDataManager.messages.count, 1)
		XCTAssertEqual(mockCoreDataManager.messages[0].content, "Foo")
		
		XCTAssertTrue(mockDatabaseUpdater.updateCalled)
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
