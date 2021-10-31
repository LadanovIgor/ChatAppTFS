//
//  User.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation

struct Channel {
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
