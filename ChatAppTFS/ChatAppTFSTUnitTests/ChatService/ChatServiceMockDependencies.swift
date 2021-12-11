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
	
	func getChannels(completion: @escaping ResultClosure<[Channel]>) {
		isChannelsListening = true
		let channel = Channel(identifier: "Baz", name: "Bar", lastMessage: "Foo", lastActivity: nil)
		completion(.success([channel]))
	}
	
	func getMessages(from channelId: String, completion: @escaping ResultClosure<[Message]>) {
		self.channelId = channelId
		isMessagesListening = true
		let message = Message(content: "Foo", created: nil, senderId: "Bar", senderName: "Baz")
		completion(.success([message]))
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
	
	func getChannels(completion: @escaping ResultClosure<[Channel]>) {
		completion(.failure(MockError.error))
	}
	
	func getMessages(from channelId: String, completion: @escaping ResultClosure<[Message]>) {
		completion(.failure(MockError.error))
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
