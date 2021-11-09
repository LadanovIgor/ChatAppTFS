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
	@IBOutlet private weak var messageView: MessageView!
	@IBOutlet private weak var senderImageView: UIImageView!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		messageView.layer.masksToBounds = true
		messageView.layer.cornerRadius = Constants.ConversationCell.messageViewCornerRadius
		messageView.clipsToBounds = true
		messageView.layer.borderWidth = Constants.ConversationCell.messageViewBorderWidth
		messageView.layer.borderColor = UIColor.black.cgColor
		senderImageView.round()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = nil
		dateLabel.text = nil
		contentLabel.text = nil
		senderImageView.image = nil
	}
	
	// MARK: - Public
	
	public func configure(with model: DBMessage, senderId: String) {
		nameLabel.text = model.senderId == senderId ? nil : model.senderName
		contentLabel.text = model.content
		guard let senderName = model.senderName, let created = model.created else {
			fatalError("Wrong DBMessage")
		}
		dateLabel.text = created.todayOrEarlier
		selectionStyle = .none
		senderImageView.image = UIImage.textImage(text: senderName.getCapitalLetters())
	}
}
