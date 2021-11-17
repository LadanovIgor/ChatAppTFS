//
//  Protocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 15.11.2021.
//

import Foundation
import CoreData.NSFetchedResultsController

protocol ConversationViewProtocol: TableViewUpdatable {
	
}

protocol ConversationPresenterProtocol: AnyObject, LifeCycleProtocol {
	var dataSource: ConversationDataSourceProtocol { get }
	func createNewMessage(with content: String)
}

protocol ConversationDataSourceProtocol: UITableViewDataSource {
	var fetchResultController: NSFetchedResultsController<DBMessage> { get }
	func performFetching()
}
