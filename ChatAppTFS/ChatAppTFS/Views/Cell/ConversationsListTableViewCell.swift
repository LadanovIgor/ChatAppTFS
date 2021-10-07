//
//  ConversationsListTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell, NibLoadable {
	
	var name: String? = nil { didSet { nameLabel.text = name } }
	var message: String? = nil { didSet { lastMessageLabel.text = message } }
	var date: Date? = nil { didSet { dateLabel.text = date?.shortDateFormateTodayOrEarlier } }
	
	var online: Bool = true {
		didSet {
			contentView.backgroundColor = online ? .yellow.withAlphaComponent(0.05) : .clear
		}
	}
	var hasUnreadMessages: Bool = true {
		didSet {
			lastMessageLabel.font = .systemFont(ofSize: 13, weight: hasUnreadMessages ? .bold : .regular)
		}
	}
	
	static let preferredHeight: CGFloat = 90

	@IBOutlet weak var lastMessageLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		profileImageView.layer.cornerRadius = profileImageView.frame.width/2
		profileImageView.layer.masksToBounds = true
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = nil
		profileImageView.image = nil
		lastMessageLabel.text = nil
		dateLabel.text = nil
		contentView.backgroundColor = .clear
		lastMessageLabel.font = .systemFont(ofSize: 13, weight: .regular)
	}
	
	public func configure(with name: String?, lastMessage: String?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
		self.name = name
		self.message = lastMessage
		self.date = date
		self.online = online
		self.hasUnreadMessages = hasUnreadMessages
		profileImageView.image = UIImage(named: "userPlaceholder")
	}
	
}
