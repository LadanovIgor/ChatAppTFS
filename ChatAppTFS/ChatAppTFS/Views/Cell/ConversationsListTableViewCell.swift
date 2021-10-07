//
//  ConversationsListTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell, NibLoadable, ConfigurableView {
	typealias ConfigurationModel = ViewModel
	
	struct ViewModel {
		let name: String?
		let lastMessage: String?
		let lastMessageDate: Date?
		let isOnline: Bool
		let hasUnreadMessages: Bool
		
		init(model: User) {
			self.name = model.name
			self.lastMessage = model.messages?.last?.text
			self.lastMessageDate = model.messages?.last?.date
			self.isOnline = model.isOnline
			self.hasUnreadMessages = !(model.messages?.last?.isRead ?? true)
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
	
	public func configure(with viewModel: ViewModel) {
		nameLabel.text = viewModel.name
		dateLabel.text = viewModel.lastMessageDate?.shortDateFormateTodayOrEarlier
		lastMessageLabel.text = viewModel.lastMessage
		contentView.backgroundColor = viewModel.isOnline ? .yellow.withAlphaComponent(0.05) : .clear
		lastMessageLabel.font = .systemFont(ofSize: 13, weight: viewModel.hasUnreadMessages ? .bold : .regular)
		profileImageView.image = UIImage(named: "userPlaceholder")
	}
	
}
