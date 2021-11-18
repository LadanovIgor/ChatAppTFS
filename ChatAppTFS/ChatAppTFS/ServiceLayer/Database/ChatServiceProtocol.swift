//
//  DatabaseServiceProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 17.11.2021.
//

import Foundation

protocol DatabaseServiceProtocol: AnyObject {
	var coreDataManager: CoreDataManagerProtocol { get }
	var firestoreManager: FireStorable { get }
	var databaseUpdater: DatabaseUpdatable? { get set }
}

protocol ChannelsServiceProtocol: DatabaseServiceProtocol {
	func addChannel(with name: String)
	func deleteChannel(with channelId: String)
	func startFetchingChannels()
	func stopFetchingChannels()
}

protocol MessagesServiceProtocol: DatabaseServiceProtocol {
	func addMessage(with content: String, senderId: String)
	func startFetchingMessages(from channelId: String)
	func stopFetchingMessages()
}
