//
//  DBChannel+CoreDataProperties.swift
//  
//
//  Created by Ladanov Igor on 31.10.2021.
//
//

import Foundation
import CoreData

@objc(DBChannel)
public class DBChannel: NSManagedObject {

}

extension DBChannel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBChannel> {
        return NSFetchRequest<DBChannel>(entityName: "DBChannel")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String?
    @NSManaged public var messages: NSSet?
	
	convenience init(with channel: Channel, context: NSManagedObjectContext) {
		self.init(context: context)
		self.identifier = channel.id
		self.lastMessage = channel.lastMessage
		self.lastActivity = channel.lastActivity ?? Date()
		self.name = channel.name
	}

}

// MARK: Generated accessors for messages
extension DBChannel {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: DBMessage)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: DBMessage)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
