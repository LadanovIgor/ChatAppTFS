//
//  ConversationDataSource.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

import Foundation
import CoreData

final class ConversationDataSource: NSObject, ConversationDataSourceProtocol {
	
	// MARK: - Properties
	
	let fetchResultController: NSFetchedResultsController<DBMessage>
	private var senderId: String?
	
	// MARK: - Init

	init(fetchResultController: NSFetchedResultsController<DBMessage>, senderId: String?) {
		self.fetchResultController = fetchResultController
		self.senderId = senderId
		super.init()
		self.performFetching()
	}
	
	// MARK: - Public
	
	func performFetching() {
		do {
			try fetchResultController.performFetch()
		} catch {
			print(error.localizedDescription)
		}
	}
}

	// MARK: - UITableViewDataSource

extension ConversationDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationTableViewCell.name,
			for: indexPath) as? ConversationTableViewCell else {
				return UITableViewCell()
			}
		let message = fetchResultController.object(at: indexPath)
		cell.configure(with: message, senderId: senderId ?? "")
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchResultController.sections else {
			fatalError("No sections in fetchedResultController")
		}
		let sectionInfo = sections[section]
		return sectionInfo.numberOfObjects
	}
}
