//
//  AppDependency.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 16.11.2021.
//

protocol TableViewUpdatable: AnyObject {
	func insert(at newIndexPath: IndexPath)
	func delete(at indexPath: IndexPath)
	func update(at indexPath: IndexPath)
	func move(at indexPath: IndexPath, to newIndexPath: IndexPath)
	func beginUpdates()
	func endUpdates()
	func reload()
}
