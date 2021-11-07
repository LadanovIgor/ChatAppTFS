//
//  User.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation
import Firebase

struct Channel: Hashable {
	let identifier: String
	let name: String
	let lastMessage: String?
	let lastActivity: Date?
	
	init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
		self.identifier = identifier
		self.lastActivity = lastActivity
		self.lastMessage = lastMessage
		self.name = name
	}
}

extension Channel {
	
	init(with document: DocumentChange) {
		let dict = document.document.data()
		let channelName = (dict["name"] as? String) ?? "No title"
		let lastMessage = dict["lastMessage"] as? String
		let lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue()
		self.lastMessage = lastMessage
		self.lastActivity = lastActivity
		self.name = channelName
		self.identifier = document.document.documentID
	}
	
	init(with dbChannel: DBChannel) {
		guard let name = dbChannel.name, let identifier = dbChannel.identifier else {
			fatalError("invalid data from database")
		}
		self.name = name
		self.lastMessage = dbChannel.lastMessage
		self.lastActivity = dbChannel.lastActivity
		self.identifier = identifier
	}
}
