//
//  FirestoreService.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation

final class ChatService {
	
	// MARK: - Properties
	
	private var channelId: String?
	weak var databaseUpdater: DatabaseUpdatable?
	var coreDataManager: CoreDataManagerProtocol
	var firestoreManager: FireStorable
	
	// MARK: - Init
		
	init(coreDataManager: CoreDataManagerProtocol, firestoreManager: FireStorable) {
		self.coreDataManager = coreDataManager
		self.firestoreManager = firestoreManager
	}

	// MARK: - Private
	
	private func updateDatabase(with channels: [Channel]) {
		coreDataManager.updateDatabase(with: channels) { [weak self] result in
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
		coreDataManager.updateDatabase(with: messages, toChannel: channelId) { [weak self] result in
			switch result {
			case .success:
				self?.databaseUpdater?.updateData()
			case .failure(let error): print(error.localizedDescription)
			}
		}
	}
}

	// MARK: - ChannelsServiceProtocol

extension ChatService: ChannelsServiceProtocol {
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
	
	func stopFetchingChannels() {
		firestoreManager.stopChannelListener()
	}

	func addChannel(with name: String) {
		firestoreManager.addChannel(with: name)
	}
	
	func deleteChannel(with channelId: String) {
		firestoreManager.deleteChannel(with: channelId)
	}
	
}

	// MARK: - MessagesServiceProtocol

extension ChatService: MessagesServiceProtocol {
	func startFetchingMessages(from channelId: String) {
		self.channelId = channelId
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
		firestoreManager.stopMessageListener()
	}
	
	func addMessage(with content: String, senderId: String) {
		firestoreManager.addMessage(with: content, senderId: senderId)
	}
}
