//
//  FirestoreManagerProtocol.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 17.11.2021.
//

import Foundation

protocol FireStorable: AnyObject {
	func getChannels(completion: @escaping ResultClosure<[Channel]>)
	func getMessages(from channelId: String, completion: @escaping ResultClosure<[Message]>)
	func addMessage(with content: String, senderId: String)
	func addChannel(with name: String)
	func deleteChannel(with channelId: String)
	func stopMessageListener()
	func stopChannelListener()
}
