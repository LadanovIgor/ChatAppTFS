//
//  Protocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation

protocol ConversationViewProtocol: AnyObject {
	func insert(at newIndexPath: IndexPath)
	func delete(at indexPath: IndexPath)
	func update(at indexPath: IndexPath)
	func move(at indexPath: IndexPath, to newIndexPath: IndexPath)
	func beginUpdates()
	func endUpdates()
	func reload()
}

protocol ConversationPresenterProtocol: AnyObject, LifeCycleProtocol {
	var dataSource: ConversationDataSourceProtocol { get }
	func createNewMessage(with content: String)
}
