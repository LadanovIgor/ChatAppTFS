//
//  ProfileStorageManagerOperation.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

final class FireStoreManager {
	
	// MARK: - Properties

	private lazy var db = Firestore.firestore()
	private lazy var channelReference = db.collection("channels")
	private var messageListener: ListenerRegistration?
	private var channelListener: ListenerRegistration?
	private var channelId: String?
	
	// MARK: - Private

	private func addMessageListener(completion: @escaping ResultClosure<[Message]>) {
		guard let channelId = channelId else { fatalError("Channel None!") }
		messageListener = channelReference.document(channelId).collection("messages").addSnapshotListener { [weak self] snapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let documents = snapshot?.documents else {
				completion(.failure(CustomFirestoreError.snapshotNone))
				return
			}
			self?.getMessages(from: documents, completion: completion)
		}
	}
	
	private func getMessages(from documents: [QueryDocumentSnapshot], completion: @escaping ResultClosure<[Message]>) {
		let messages = documents.compactMap { (document) -> Message? in
			do {
				let message = try document.data(as: Message.self)
				return message
			} catch {
				print(error.localizedDescription)
				return nil
			}
		}
		completion(.success(messages))
	}
	
	private func addChannelListener(completion: @escaping ResultClosure<[Channel]>) {
		channelListener = channelReference.addSnapshotListener { [weak self] snapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let documents = snapshot?.documents else {
				completion(.failure(CustomFirestoreError.snapshotNone))
				return
			}
			self?.getChannelsFrom(documents: documents, completion: completion)
		}
	}
	
	private func getChannelsFrom(
		documents: [QueryDocumentSnapshot],
		completion: @escaping ResultClosure<[Channel]>
	) {
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
		completion(.success(channels))
	}
	
	// MARK: - Public
	
	public func configure() {
		FirebaseApp.configure()
	}
}

	// MARK: - FireStorable

extension FireStoreManager: FireStorable {
	public func getChannels(completion: @escaping ResultClosure<[Channel]>) {
		addChannelListener(completion: completion)
	}
	
	public func addChannel(with name: String) {
		channelReference.addDocument(data: ["name": name, "lastActivity": Timestamp(date: Date())])
	}
	
	public func stopChannelListener() {
		channelListener?.remove()
	}
	
	public func deleteChannel(with channelId: String) {
		channelReference.document(channelId).delete()
	}
	
	public func getMessages(from channelId: String, completion: @escaping ResultClosure<[Message]>) {
		self.channelId = channelId
		addMessageListener(completion: completion)
	}
	
	public func addMessage(with content: String, senderId: String) {
		guard let channelId = channelId else { fatalError("Channel None!") }
		let message = Message(content: content, senderId: senderId, created: Date(), senderName: "🍔 + 🍺 = 🤤")
		do {
			_ = try channelReference.document(channelId).collection("messages").addDocument(from: message)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	public func stopMessageListener() {
		messageListener?.remove()
	}
}
