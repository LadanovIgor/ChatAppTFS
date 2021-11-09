//
//  Message.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation
import Firebase

struct Message: Codable {
	let content: String
	let created: Date
	let senderId: String?
	let senderName: String?
}

extension Message {
	init(content: String, senderId: String, created: Date = Date(), senderName: String = "🥷🏾") {
		self.content = content
		self.senderId = senderId
		self.created = created
		self.senderName = senderName
	}
	
	init(dbMessage: DBMessage) {
		guard let created = dbMessage.created, let senderId = dbMessage.senderId,
			  let content = dbMessage.content, let senderName = dbMessage.senderName else {
				  fatalError("invalid data from database")
			  }
		self.created = created
		self.senderName = senderName
		self.senderId = senderId
		self.content = content
	}
}
