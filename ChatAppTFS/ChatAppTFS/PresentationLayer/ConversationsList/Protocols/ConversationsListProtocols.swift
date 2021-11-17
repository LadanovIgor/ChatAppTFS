//
//  Protocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import Foundation
import CoreData.NSFetchedResultsController

protocol ConversationsListViewProtocol: TableViewUpdatable {
	
}

protocol ConversationsListPresenterProtocol: AnyObject, LifeCycleProtocol {
	var dataSource: ConversationsListDataSourceProtocol { get }
	func createNewChannel(with name: String)
	func leftBarButtonTapped()
	func rightBarButtonTapped()
	func didTapAt(indexPath: IndexPath)
	func getUserName(completion: @escaping (ResultClosure<String>))
}

protocol ConversationsListDataSourceProtocol: UITableViewDataSource {
	var fetchResultController: NSFetchedResultsController<DBChannel> { get }
	func performFetching()
}
