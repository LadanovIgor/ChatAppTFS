//
//  DBMessage.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation
import CoreData

@objc(DBMessage)
public class DBMessage: NSManagedObject {

}

extension DBMessage {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<DBMessage> {
		return NSFetchRequest<DBMessage>(entityName: "DBMessage")
	}

	@NSManaged public var content: String?
	@NSManaged public var created: Date?
	@NSManaged public var senderId: String?
	@NSManaged public var senderName: String?
	@NSManaged public var channel: DBChannel?

	convenience init(with message: Message, context: NSManagedObjectContext) {
		self.init(context: context)
		self.content = message.content
		self.senderId = message.senderId ?? "no Id"
		self.senderName = message.senderName ?? "Anonymous"
		self.created = message.created?.dateValue()
	}
}
