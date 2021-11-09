//
//  DatabaseManager.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 31.10.2021.
//

import Foundation
import CoreData

final class DatabaseManager {
	
	// MARK: - Properties
	
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
	
	lazy var viewContext = persistentContainer.viewContext
	
	private init() {}
	
	// MARK: - Private
	
	private func saveContext(_ context: NSManagedObjectContext, completion: @escaping ResultClosure<Bool>) {
		context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		do {
			try context.save()
			completion(.success(true))
		} catch {
			completion(.failure(DatabaseError.failureSaving))
		}
	}
	
	// MARK: - Public
	
	public func save(channel: Channel, completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { [weak self] context in
			_ = DBChannel(with: channel, context: context)
			self?.saveContext(context, completion: completion)
		}
	}
	
	public func delete(channel: DBChannel, completion: @escaping ResultClosure<Bool>) {
		viewContext.delete(channel)
		saveContext(viewContext, completion: completion)
	}
	
	public func save(messages: [Message], toChannel channelId: String, completion: @escaping ResultClosure<Bool>) {
		persistentContainer.performBackgroundTask { [weak self] context in
			let dbMessages: [DBMessage] = messages.map { DBMessage(with: $0, context: context) }
			let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
			if let dbChannels = try? context.fetch(fetchRequest), let dbChannel = dbChannels.first {
				dbChannel.addToMessages(NSSet(array: dbMessages))
				self?.saveContext(context, completion: completion)
			} else {
				completion(.failure(DatabaseError.failureFetching))
			}
			
		}
	}
}
