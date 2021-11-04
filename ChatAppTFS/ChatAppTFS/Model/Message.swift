//
//  Message.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation
import Firebase
import UIKit

struct Message {
	let content: String
	let created: Date
	let senderId: String
	let senderName: String
}

extension Message {
	
	init(with document: QueryDocumentSnapshot) {
		let dict = document.data()
		let content = dict["content"] as? String ?? ""
		let senderId = dict["senderId"] as? String ?? ""
		let created = (dict["created"] as? Timestamp)?.dateValue() ?? Date(timeIntervalSinceReferenceDate: 10)
		var senderName = dict["senderName"] as? String ?? ""
		if senderName == "" { senderName = "Anonymous" }
		self.content = content
		self.created = created
		self.senderId = senderId
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
