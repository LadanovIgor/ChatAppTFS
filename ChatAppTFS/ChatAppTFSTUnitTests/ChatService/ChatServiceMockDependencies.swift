//
//  ChatServiceMockDependencies.swift
//  ChatAppTFSTUnitTests
//
//  Created by Ladanov Igor on 07.12.2021.
//

@testable import ChatAppTFS
import CoreData

class MockFirestoreManager: FireStorable {
	
	var channelId: String?
	var deleteChannelId: String?
	var name: String?
	var senderId: String?
	var content: String?
	
	var isMessagesListening = false
	var isChannelsListening = false
    var channels: [Channel] = []
    var messages: [Message] = []
	
	func getChannels(completion: @escaping ResultClosure<[Channel]>) {
		isChannelsListening = true
		completion(.success(channels))
	}
	
	func getMessages(from channelId: String, completion: @escaping ResultClosure<[Message]>) {
		self.channelId = channelId
		isMessagesListening = true
		completion(.success(messages))
	}
	
	func addMessage(with content: String, senderId: String) {
		self.senderId = senderId
		self.content = content
	}
	
	func addChannel(with name: String) {
		self.name = name
	}
	
	func deleteChannel(with channelId: String) {
		self.deleteChannelId = channelId
	}
	
	func stopMessageListener() {
		isMessagesListening = false
	}
	
	func stopChannelListener() {
		isMessagesListening = false
	}
}

class MockFirestoreManagerFailure: FireStorable {
    
    var error = MockError.error
	
	func getChannels(completion: @escaping ResultClosure<[Channel]>) {
		completion(.failure(error))
	}
	
	func getMessages(from channelId: String, completion: @escaping ResultClosure<[Message]>) {
		completion(.failure(error))
	}
	
	func addMessage(with content: String, senderId: String) {}
	func addChannel(with name: String) {}
	func deleteChannel(with channelId: String) {}
	func stopMessageListener() {}
	func stopChannelListener() {}
}

class MockCoreDataManager: CoreDataManagerProtocol {
	
	var channels = [Channel]()
	var messages = [Message]()
	var channelId: String?
	
	func updateDatabase(with channels: [Channel], completion: @escaping ResultClosure<Bool>) {
		self.channels = channels
		completion(.success(true))
	}
	
	func updateDatabase(with messages: [Message], toChannel channelId: String, completion: @escaping ResultClosure<Bool>) {
		self.messages = messages
		self.channelId = channelId
		completion(.success(true))
	}
	
	var viewContext: NSManagedObjectContext = NSPersistentContainer(name: "Foo").viewContext
	
}

class MockDatabaseUpdater: DatabaseUpdatable {
	var updateCalled = false
	
	func updateData() {
		updateCalled = true
	}
}
