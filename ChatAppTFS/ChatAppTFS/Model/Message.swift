//
//  Message.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation
import Firebase

struct Message {
	let content: String
	let created: Date
	let senderId: String
	let senderName: String
	
	init(with dict: [String: Any]) {
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
}
