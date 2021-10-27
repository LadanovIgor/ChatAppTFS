//
//  TableView+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 25.10.2021.
//

import Foundation

extension UITableView {

	func scrollToBottom(isAnimated: Bool = true) {
		DispatchQueue.main.async {
			guard self.numberOfSections > 0, self.numberOfRows(inSection: 0) > 0 else {
				return
			}
			let indexPath = IndexPath(
				row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1,
				section: self.numberOfSections - 1)
			if self.hasRowAtIndexPath(indexPath: indexPath) {
				self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
			}
		}
	}
	
	func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
		return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
	}
}
