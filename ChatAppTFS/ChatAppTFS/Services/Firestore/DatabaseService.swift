//
//  FirestoreService.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation

protocol DatabaseServiceProtocol: AnyObject {
	func addChannel(with name: String)
	func deleteChannel(with channelId: String)
	func addMessage(with content: String, senderId: String)
	var databaseManager: DatabaseProtocol { get }
	var firestoreManager: FireStorable { get }
	func startFetchingChannels()
	func startFetchingMessages(from channelId: String)
	func stopFetchingMessages()
}

final class DatabaseService: DatabaseServiceProtocol {

	private var channelId: String?
	weak var databaseUpdater: DatabaseUpdatable?
	var databaseManager: DatabaseProtocol
	var firestoreManager: FireStorable
		
	init(databaseManager: DatabaseProtocol, firestoreManager: FireStorable) {
		self.databaseManager = databaseManager
		self.firestoreManager = firestoreManager
	}
	
	init(with channelId: String, databaseManager: DatabaseProtocol, firestoreManager: FireStorable) {
		self.databaseManager = databaseManager
		self.firestoreManager = firestoreManager
		self.channelId = channelId
	}
	
	func startFetchingChannels() {
		firestoreManager.getChannels { [weak self] result in
			switch result {
			case .success(let channels):
			self?.updateDatabase(with: channels)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func startFetchingMessages(from channelId: String) {
		firestoreManager.getMessages(from: channelId) { [weak self] result in
			switch result {
			case .success(let messages):
				self?.updateDatabase(with: messages)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func stopFetchingMessages() {
		firestoreManager.stopListener()
	}
	
	func addMessage(with content: String, senderId: String) {
		firestoreManager.addMessage(with: content, senderId: senderId)
	}

	func addChannel(with name: String) {
		firestoreManager.addChannel(with: name)
	}
	
	func deleteChannel(with channelId: String) {
		firestoreManager.deleteChannel(with: channelId)
	}
	
	private func updateDatabase(with channels: [Channel]) {
		databaseManager.updateDatabase(with: channels) { [weak self] result in
			switch result {
			case .success:
				self?.databaseUpdater?.updateData()
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	private func updateDatabase(with messages: [Message]) {
		guard let channelId = channelId else {
			fatalError("Channel None!")
		}
		databaseManager.updateDatabase(with: messages, toChannel: channelId) { [weak self] result in
			switch result {
			case .success:
				self?.databaseUpdater?.updateData()
			case .failure(let error): print(error.localizedDescription)
			}
		}
	}
}
