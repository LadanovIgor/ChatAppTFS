//
//  Protocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import Foundation
import CoreData.NSFetchedResultsController

protocol ConversationsListViewProtocol: TableViewUpdatable {
	func set(userName: String)
}

protocol ConversationsListPresenterProtocol: AnyObject, LifeCycleProtocol {
	var dataSource: ConversationsListDataSourceProtocol { get }
	func createNewChannel(with name: String)
	func leftBarButtonTapped()
	func rightBarButtonTapped()
	func didTapAt(indexPath: IndexPath)
}

protocol ConversationsListDataSourceProtocol: UITableViewDataSource {
	var fetchResultController: NSFetchedResultsController<DBChannel> { get }
	func performFetching()
}
