//
//  CoreDataManagerProtococ.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 17.11.2021.
//

import Foundation
import CoreData.NSManagedObjectContext

protocol CoreDataManagerProtocol: AnyObject {
	func updateDatabase(with channels: [Channel], completion: @escaping ResultClosure<Bool>)
	func updateDatabase(with messages: [Message], toChannel channelId: String, completion: @escaping ResultClosure<Bool>)
	var viewContext: NSManagedObjectContext { get }
}
