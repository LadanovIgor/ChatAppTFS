//
//  ConversationTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, NibLoadable {
	
	// MARK: - Properties

	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	@IBOutlet private weak var contentLabel: UILabel!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = nil
		dateLabel.text = nil
		contentLabel.text = nil
	}
	
	public func configure(with model: Message, senderId: String) {
		nameLabel.text = model.senderId == senderId ? nil : model.senderName
		contentLabel.text = model.content
		dateLabel.text = model.created.shortDateFormateTodayOrEarlier
		selectionStyle = .none
	}
}
