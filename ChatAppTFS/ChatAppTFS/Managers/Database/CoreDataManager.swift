//
//  DatabaseManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 31.10.2021.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
	func updateDatabase(with channels: [Channel], completion: @escaping ResultClosure<Bool>)
	func updateDatabase(with messages: [Message], toChannel channelId: String, completion: @escaping ResultClosure<Bool>)
	var viewContext: NSManagedObjectContext { get }
}

final class CoreDataManager: CoreDataManagerProtocol {
	
	// MARK: - Properties
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "ChatDB")
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError(error.localizedDescription)
			}
		}
		return container
	}()
	lazy var viewContext = persistentContainer.viewContext
	
	// MARK: - Private
	
	private func saveContext(_ context: NSManagedObjectContext, completion: @escaping ResultClosure<Bool>) {
		do {
			try context.save()
			completion(.success(true))
		} catch {
			completion(.failure(DatabaseError.failureSaving))
		}
	}
	
	private func deleteChannelIfNeeded(_ channels: [Channel], completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { [weak self] context in
			guard let self = self else { return }
			do {
				let dbChannels = try self.fetchChannelFromDatabase(context: context)
				dbChannels.forEach { dbChannel in
					guard let channelId = dbChannel.identifier else {
						fatalError("Wrong fetching database. Channel does not have identifier")
					}
					if !channels.contains(channelId: channelId) {
						context.delete(dbChannel)
						self.saveContext(context, completion: completion)
					}
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	private func fetchChannelFromDatabase(with channelId: String? = nil, context: NSManagedObjectContext) throws -> [DBChannel] {
		let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
		if let channelId = channelId {
			fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
		}
		do {
			return try context.fetch(fetchRequest)
		} catch {
			throw error
		}
	}
	
	// MARK: - Public
	
	public func updateDatabase(with channels: [Channel], completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { [weak self] context in
			guard let self = self else { return }
			channels.forEach { channel in
				guard let channelId = channel.id else {
					fatalError("Channel has no identifier")
				}
				do {
					let dbChannels = try self.fetchChannelFromDatabase(with: channelId, context: context)
					if dbChannels.count == 0 {
						_ = DBChannel(with: channel, context: context)
						self.saveContext(context, completion: completion)
					} else {
						guard let dbChannel = dbChannels.first else {
							fatalError("Compiler cannot count")
						}
						dbChannel.name = channel.name
						dbChannel.lastMessage = channel.lastMessage
						dbChannel.lastActivity = channel.lastActivity
						
						self.saveContext(context, completion: completion)
					}
				} catch {
					completion(.failure(error))
				}
			}
		}
		deleteChannelIfNeeded(channels, completion: completion)
	}
	
	public func updateDatabase(with messages: [Message], toChannel channelId: String, completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { [weak self] context in
			guard let self = self else { return }
			do {
				let dbChannels = try self.fetchChannelFromDatabase(with: channelId, context: context)
				guard let dbChannel = dbChannels.first else {
					fatalError("There is no channel with this identifier in the database")
				}
				let sortDescriptor = NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: true)
				guard let dbMessages = dbChannel.messages?.sortedArray(using: [sortDescriptor]) as? [DBMessage] else {
					fatalError("DatabaseError! Channel has no array of messages")
				}
				guard let lastMessage = dbMessages.last, let lastMessageCreated = lastMessage.created else {
					messages.forEach { message in
						let dbMessage = DBMessage(with: message, context: context)
						dbChannel.addToMessages(dbMessage)
					}
					self.saveContext(context, completion: completion)
					return
				}
				let newMessages = messages.filter { message in
					guard let created = message.created?.dateValue() else {
						fatalError("Wrong data from firestore. Message has no created date")
					}
					return created > lastMessageCreated
				}
				newMessages.forEach { message in
					let dbMessage = DBMessage(with: message, context: context)
					dbChannel.addToMessages(dbMessage)
				}
				self.saveContext(context, completion: completion)
			} catch {
				completion(.failure(error))
			}
		}
	}
}
