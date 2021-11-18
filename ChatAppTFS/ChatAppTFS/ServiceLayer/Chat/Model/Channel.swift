//
//  User.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Channel: Codable {
	@DocumentID var id: String?
	let name: String?
	let lastMessage: String?
	let lastActivity: Date?
	
	init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
		self.id = identifier
		self.lastActivity = lastActivity
		self.lastMessage = lastMessage
		self.name = name
	}
}

extension Channel {
	init(with dbChannel: DBChannel) {
		guard let name = dbChannel.name, let identifier = dbChannel.identifier else {
			fatalError("invalid data from database")
		}
		self.name = name
		self.lastMessage = dbChannel.lastMessage
		self.lastActivity = dbChannel.lastActivity
		self.id = identifier
	}
}
