//
//  ConversationListDataSource.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import UIKit
import CoreData.NSFetchedResultsController

class ConversationsListDataSource: NSObject, ConversationsListDataSourceProtocol {
	
	// MARK: - Properties
	
	let fetchResultController: NSFetchedResultsController<DBChannel>
	private weak var presenter: ConversationsListPresenter?
	
	// MARK: - Init

	init(fetchResultController: NSFetchedResultsController<DBChannel>, presenter: ConversationsListPresenter) {
		self.presenter = presenter
		self.fetchResultController = fetchResultController
		super.init()
		self.performFetching()
	}
	
	// MARK: - Private
	
	private func validateIndexPath(_ indexPath: IndexPath) -> Bool {
		guard let sections = fetchResultController.sections else {
			fatalError("No sections in fetchedResultController")
		}
		if indexPath.section < sections.count {
		   if indexPath.row < sections[indexPath.section].numberOfObjects {
			  return true
		   }
		}
		return false
	}
	
	// MARK: - Public
	
	public func performFetching() {
		do {
			try fetchResultController.performFetch()
		} catch {
			print(error.localizedDescription)
		}
	}
}

// MARK: - UITableViewDataSource

extension ConversationsListDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		return fetchResultController.sections?.count ?? 0
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchResultController.sections else {
			fatalError("No sections in fetchedResultController")
		}
		let sectionInfo = sections[section]
		return sectionInfo.numberOfObjects
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationsListTableViewCell.name,
			for: indexPath) as? ConversationsListTableViewCell else {
				return UITableViewCell()
			}
		if validateIndexPath(indexPath) {
			let channel = fetchResultController.object(at: indexPath)
			cell.configure(with: .init(with: channel))
			cell.layoutIfNeeded()
		}
		return cell
	}
	
	public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let channel = fetchResultController.object(at: indexPath)
			guard let id = channel.identifier else {
				fatalError("Channel don't have identifier")
			}
			presenter?.deleteChannel(with: id)
		}
	}
}
