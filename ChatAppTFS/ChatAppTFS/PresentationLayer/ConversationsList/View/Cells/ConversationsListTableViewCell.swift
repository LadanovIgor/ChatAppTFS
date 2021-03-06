//
//  ConversationsListTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell, NibLoadable, ConfigurableView {
	
	// MARK: - ViewModel
	
	typealias ConfigurationModel = ViewModel
	
	struct ViewModel {
		let name: String?
		let lastMessage: String?
		let lastMessageDate: Date?
		let isOnline: Bool
		let hasUnreadMessages: Bool
		
		init(with channel: DBChannel) {
			self.name = channel.name
			self.lastMessage = channel.lastMessage
			self.lastMessageDate = channel.lastActivity
			self.isOnline = true
			self.hasUnreadMessages = false
		}
	}
	
	// MARK: - Outlets and Properties
	
	static let preferredHeight: CGFloat = 90
	
	@IBOutlet weak var lastMessageLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
		profileImageView.layer.masksToBounds = true
		removeBottomSeparator()
		selectionStyle = .none
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = nil
		profileImageView.image = nil
		lastMessageLabel.text = nil
		dateLabel.text = nil
		lastMessageLabel.font = .systemFont(ofSize: 13, weight: .regular)
		contentView.backgroundColor = .clear
	}
	
	// MARK: - Public
	
	public func configure(with viewModel: ViewModel) {
		nameLabel.text = viewModel.name
		dateLabel.text = viewModel.lastMessageDate?.todayOrEarlier
		lastMessageLabel.font = .systemFont(ofSize: 13, weight: viewModel.hasUnreadMessages ? .bold : .regular)
		profileImageView.image = UIImage.textImage(text: viewModel.name?.getCapitalLetters())
		guard let lastMessage = viewModel.lastMessage else {
			lastMessageLabel.text = "No messages yet"
			return
		}
		lastMessageLabel.text = lastMessage
	}
	
}
