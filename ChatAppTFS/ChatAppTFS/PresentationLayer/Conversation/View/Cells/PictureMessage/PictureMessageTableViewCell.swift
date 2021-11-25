//
//  PictureMessageTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.11.2021.
//

import UIKit

class PictureMessageTableViewCell: UITableViewCell, NibLoadable {

	// MARK: - Properties

	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	@IBOutlet private weak var contentImageView: UIImageView!
	@IBOutlet private weak var messageView: AppMessageView!
	@IBOutlet private weak var senderImageView: UIImageView!
	@IBOutlet private weak var contentLabel: UILabel!
	@IBOutlet private weak var spinner: UIActivityIndicatorView!
	
	private var content: String?
	
	lazy var imageLoaded: ResultClosure<Data> = { [weak self] result in
		switch result {
		case .success(let data):
			guard let image = UIImage(data: data) else {
				self?.failureImageLoading()
				return
			}
			self?.contentImageView.image = image
			self?.spinner.stopAnimating()
			self?.contentImageView.isHidden = false
		case .failure(let error):
			self?.failureImageLoading()
		}
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		selectionStyle = .none
		messageView.layer.masksToBounds = true
		messageView.layer.cornerRadius = Constants.ConversationCell.messageViewCornerRadius
		messageView.clipsToBounds = true
		messageView.layer.borderWidth = Constants.ConversationCell.messageViewBorderWidth
		messageView.layer.borderColor = UIColor.black.cgColor
		senderImageView.round()
		contentImageView.layer.cornerRadius = 6
		contentImageView.layer.masksToBounds = true
		contentLabel.isHidden = true
		contentImageView.isHidden = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		transform = CGAffineTransform(rotationAngle: CGFloat.pi)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = nil
		dateLabel.text = nil
		contentImageView.image = nil
		senderImageView.image = nil
		contentLabel.isHidden = true
		contentLabel.text = nil
		contentImageView.isHidden = true
	}
	
	private func failureImageLoading() {
		spinner.stopAnimating()
		contentImageView.isHidden = true
		contentLabel.isHidden = false
		contentLabel.text = "Unsuccessful image loading with url: \n\(self.content ?? "")"
	}

	// MARK: - Public
	
	public func configure(with model: DBMessage, senderId: String) {
		spinner.startAnimating()
		nameLabel.text = model.senderId == senderId ? nil : model.senderName
		contentImageView.image = UIImage(named: "image")
		content = model.content
		if let senderName = model.senderName, let created = model.created {
			dateLabel.text = created.todayOrEarlier
			senderImageView.image = UIImage.textImage(text: senderName.getCapitalLetters())
		}
	}
    
}
