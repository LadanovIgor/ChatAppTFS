//
//  FirestoreService.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

protocol FirestoreServiceProtocol: AnyObject {
	func addChannel(with name: String)
	func deleteChannel(with channelId: String)
	func addMessage(with content: String, senderId: String)
	var databaseManager: DatabaseProtocol? { get set }
}

final class FirestoreService: FirestoreServiceProtocol {

	private lazy var db = Firestore.firestore()
	private lazy var channelReference = db.collection("channels")
	private lazy var messageReference: CollectionReference = {
		guard let channelIdentifier = channelId else { fatalError("Channel None!") }
		return db.collection("channels").document(channelIdentifier).collection("messages")
	}()
	
	private var channelId: String?
	weak var databaseUpdater: DatabaseUpdatable?
	var databaseManager: DatabaseProtocol?
		
	init(databaseManager: DatabaseProtocol?) {
		self.databaseManager = databaseManager
		addChannelListener()
	}
	
	init(with channelId: String, databaseManager: DatabaseProtocol?) {
		self.databaseManager = databaseManager
		self.channelId = channelId
		addMessageListener()
	}
	
	private func addMessageListener() {
		messageReference.addSnapshotListener { [weak self] snapshot, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let documents = snapshot?.documents else {
				print(CustomFirebaseError.snapshotNone.localizedDescription)
				return
			}
			self?.getMessages(from: documents)
		}
	}
	
	private func getMessages(from documents: [QueryDocumentSnapshot]) {
		let messages = documents.compactMap { (document) -> Message? in
			do {
				let message = try document.data(as: Message.self)
				return message
			} catch {
				print(error.localizedDescription)
				return nil
			}
		}
		saveToDatabase(messages)
	}
	
	private func saveToDatabase(_ messages: [Message]) {
		guard let channelId = channelId else {
			fatalError("Channel None!")
		}
		databaseManager?.updateDatabase(with: messages, toChannel: channelId) { [weak self] result in
			switch result {
			case .success:
				self?.databaseUpdater?.updateData()
			case .failure(let error): print(error.localizedDescription)
			}
		}
	}
	
	func addMessage(with content: String, senderId: String) {
		do {
			_ = try messageReference.addDocument(from: Message(content: content, senderId: senderId))
		} catch {
			print(error.localizedDescription)
		}
	}

	func addChannel(with name: String) {
		channelReference.addDocument(data: ["name": name, "lastActivity": Timestamp(date: Date())])
	}
	
	func deleteChannel(with channelId: String) {
		channelReference.document(channelId).delete()
	}
	
	private func addChannelListener() {
		channelReference.addSnapshotListener { [weak self] snapshot, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let documents = snapshot?.documents else {
				print(CustomFirebaseError.snapshotNone.localizedDescription)
				return
			}
			self?.getChannelsFrom(documents: documents)
		}
	}
	
	private func getChannelsFrom(documents: [QueryDocumentSnapshot]) {
		let channels = documents.compactMap { (document) -> Channel? in
			do {
				let channel = try document.data(as: Channel.self)
				guard let channel = channel else {
					fatalError("Channel decoding error")
				}
				return channel
			} catch {
				print("Some joker created channel with the wrong value type")
				return nil
			}
		}
		updateDatabase(with: channels)
	}

	private func updateDatabase(with channels: [Channel]) {
		databaseManager?.updateDatabase(with: channels) { [weak self] result in
			switch result {
			case .success:
				self?.databaseUpdater?.updateData()
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}
