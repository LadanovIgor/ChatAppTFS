//
//  DatabaseServiceProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 17.11.2021.
//

import Foundation

protocol DatabaseServiceProtocol: AnyObject {
	func addChannel(with name: String)
	func deleteChannel(with channelId: String)
	func addMessage(with content: String, senderId: String)
	var coreDataManager: CoreDataManagerProtocol { get }
	var firestoreManager: FireStorable { get }
	func startFetchingChannels()
	func startFetchingMessages(from channelId: String)
	func stopFetchingMessages()
	func stopFetchingChannels()
	var databaseUpdater: DatabaseUpdatable? { get set }
}
