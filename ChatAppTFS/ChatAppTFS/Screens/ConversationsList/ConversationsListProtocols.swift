//
//  Protocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.11.2021.
//

import Foundation

protocol ConversationsListViewProtocol: AnyObject {
	func insert(at newIndexPath: IndexPath)
	func delete(at indexPath: IndexPath)
	func update(at indexPath: IndexPath)
	func move(at indexPath: IndexPath, to newIndexPath: IndexPath)
	func beginUpdates()
	func endUpdates()
	func reload()
}

protocol ConversationsListPresenterProtocol: AnyObject, LifeCycleProtocol {
	var dataSource: ConversationListDataSource { get }
	func changeTheme(for theme: ThemeProtocol)
	func createNewChannel(with name: String)
	func leftBarButtonTapped()
	func rightBarButtonTapped()
	func didTapAt(indexPath: IndexPath)
	func getUserName(completion: @escaping (ResultClosure<String>))
}
