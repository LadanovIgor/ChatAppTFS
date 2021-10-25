//
//  ConversationTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, NibLoadable, ConfigurableView {
	
	// MARK: - ViewModel
	
	typealias ConfigurationModel = Message
	
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
	
	public func configure(with model: Message) {
		nameLabel.text = model.senderName
		contentLabel.text = model.content
		dateLabel.text = model.created.shortDateFormateTodayOrEarlier
		selectionStyle = .none
	}
}
