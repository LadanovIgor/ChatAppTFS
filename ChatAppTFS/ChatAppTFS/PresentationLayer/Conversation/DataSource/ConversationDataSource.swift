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
	private let senderRequest = RequestSender()
	
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
	
	func getImageData(urlString: String, completion: @escaping ResultClosure<Data>) {
		let request = RequestsFactory.DataRequest.imageRequest(url: urlString)
		senderRequest.send(request: request, completion: completion)
	}
}

	// MARK: - UITableViewDataSource

extension ConversationDataSource {
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = fetchResultController.object(at: indexPath)
		if let content = message.content, content.isValidURL {
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: PictureMessageTableViewCell.name,
				for: indexPath) as? PictureMessageTableViewCell else {
					return UITableViewCell()
				}
			cell.configure(with: message, senderId: senderId ?? "")
			cell.tag = indexPath.row
			getImageData(urlString: content) { result in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					if cell.tag == indexPath.row {
						cell.imageLoaded(result)
					}
				}
			}
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: ConversationTableViewCell.name,
				for: indexPath) as? ConversationTableViewCell else {
					return UITableViewCell()
				}
			cell.configure(with: message, senderId: senderId ?? "")
			return cell
		}
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchResultController.sections else {
			fatalError("No sections in fetchedResultController")
		}
		let sectionInfo = sections[section]
		return sectionInfo.numberOfObjects
	}
}
