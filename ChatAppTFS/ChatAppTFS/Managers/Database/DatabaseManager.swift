//
//  DatabaseManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 31.10.2021.
//

import Foundation
import CoreData

final class DatabaseManager {
	
	static let shared = DatabaseManager()
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "ChatDB")
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError(error.localizedDescription)
			}
		}
		return container
	}()
	
	private lazy var viewContext = persistentContainer.viewContext
	
	private init() {}
	
	func fetchChannels(completion: @escaping ResultClosure<[Channel]>) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DatabaseKey.channel)
		if let dbChannels = try? viewContext.fetch(fetchRequest) as? [DBChannel] {
			let channels = dbChannels.map { Channel(with: $0) }
			completion(.success(channels))
		} else {
			completion(.failure(DatabaseError.failureFetching))
		}
	}
	
	func fetchMessagesFrom(channelId: String, completion: @escaping ResultClosure<[Message]?>) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DatabaseKey.channel)
		fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
		if let dbChannels = try? viewContext.fetch(fetchRequest) as? [DBChannel] {
			guard let dbMessages = dbChannels.first?.messages else {
				completion(.success(nil))
				return
			}
			let messages = dbMessages.toArray().map { Message(dbMessage: $0)}
			completion(.success(messages))
		} else {
			completion(.failure(DatabaseError.failureFetching))
		}
	}
	
	func save(channels: [Channel], completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { context in
			channels.forEach { channel in
				let dbChannel = DBChannel(context: context)
				dbChannel.identifier = channel.identifier
				dbChannel.lastMessage = channel.lastMessage
				dbChannel.lastActivity = channel.lastActivity
				dbChannel.name = channel.name
				context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
				do {
					try context.save()
					completion(.success(true))
				} catch {
					completion(.failure(DatabaseError.failureSaving))
				}
			}
		}
	}
	
	func save(messages: [Message], toChannel channelId: String, completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { context in
			let dbMessages: [DBMessage] = messages.map { message in
				let dbMessage = DBMessage(context: context)
				dbMessage.content = message.content
				dbMessage.created = message.created
				dbMessage.senderId = message.senderId
				dbMessage.senderName = message.senderName
				return dbMessage
			}
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DatabaseKey.channel)
			fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
			if let dbChannels = try? context.fetch(fetchRequest) as? [DBChannel], let dbChannel = dbChannels.first {
				context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
				dbChannel.addToMessages(NSSet(array: dbMessages))
				do {
					try context.save()
					completion(.success(true))
				} catch {
					completion(.failure(DatabaseError.failureSaving))
				}
			} else {
				completion(.failure(DatabaseError.failureFetching))
			}
			
		}
	}
}
