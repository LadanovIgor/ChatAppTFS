//
//  ConversationTableViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, ConfigurableView {
	
	// MARK: - ViewModel
	
	typealias ConfigurationModel = ViewModel

	struct ViewModel {
		let message: String?
		let messageDate: Date?
		let isSelfMessage: Bool?
		
		init(model: Message) {
			self.message = model.text
			self.messageDate = model.date
			self.isSelfMessage = model.isSelfMessage
		}
	}
	
	// MARK: - Properties

	static let identifier = "ConversationTableViewCell"
	static let preferredHeight: CGFloat = 90
	private var labelWidth: CGFloat {
		contentView.frame.width * Constants.ConversationCell.labelWidthMultiplier
	}
	
	private let messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textAlignment = .left
		label.backgroundColor = .clear
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private var labelLeftConstraint: NSLayoutConstraint!
	private var labelRightConstraint: NSLayoutConstraint!
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setUpMessageLabel()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		messageLabel.text = nil
	}
	
	// MARK: - Private
	
	private func setUpConstraints() {
		contentView.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "V:|-offset-[label]-offset-|",
			metrics: ["width": labelWidth, "offset": Constants.ConversationCell.offset],
			views: ["label": messageLabel]))
		labelLeftConstraint = NSLayoutConstraint(item: messageLabel,
												 attribute: .left,
												 relatedBy: .equal,
												 toItem: contentView,
												 attribute: .left,
												 multiplier: 1.0,
												 constant: Constants.ConversationCell.offset)
		labelRightConstraint = NSLayoutConstraint(item: messageLabel,
												 attribute: .right,
												 relatedBy: .equal,
												 toItem: contentView,
												 attribute: .right,
												 multiplier: 1.0,
												 constant: Constants.ConversationCell.offset)
		messageLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
		positionLabelToLeft()
	}
	
	private func positionLabelToLeft() {
		labelRightConstraint.isActive = false
		labelLeftConstraint.isActive = true
		contentView.layoutIfNeeded()
	}
	
	private func positionLabelToRight() {
		labelLeftConstraint.isActive = false
		labelRightConstraint.isActive = true
		contentView.layoutIfNeeded()
	}

	private func setUpMessageLabel() {
		contentView.addSubview(messageLabel)
		setUpConstraints()
	}
	
	// MARK: - Public
	
	public func configure(with viewModel: ViewModel) {
		messageLabel.text = viewModel.message
		switch viewModel.isSelfMessage {
			case false: positionLabelToLeft()
			default: positionLabelToRight()
		}
	}
}
