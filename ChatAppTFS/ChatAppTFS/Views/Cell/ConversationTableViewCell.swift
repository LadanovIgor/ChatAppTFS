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
	private var labelWidth: CGFloat { contentView.frame.width * 0.7 }
	private let spacing: CGFloat = 10
	
	private let messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textAlignment = .left
//		label.textColor = .black
		label.backgroundColor = .clear
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setUpMessageLabel()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		messageLabel.text = nil
	}
	
	// MARK: - Private
	
	private func positionMessageDepending(on isSelf: Bool) {
		contentView.removeConstraints(contentView.constraints)
		let visualFormat = isSelf ? "H:[label(labelWidth)]-spacing-|,V:|-spacing-[label]-spacing-|" :
									"H:|-spacing-[label(labelWidth)],V:|-spacing-[label]-spacing-|"
		contentView.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: visualFormat,
			metrics: ["labelWidth": labelWidth, "spacing": spacing ],
			views: ["label": messageLabel]))
	}
	
	private func setUpMessageLabel() {
		contentView.addSubview(messageLabel)
		positionMessageDepending(on: false)
	}
	
	// MARK: - Public
	
	public func configure(with viewModel: ViewModel) {
		messageLabel.text = viewModel.message
		positionMessageDepending(on: viewModel.isSelfMessage ?? true)
		setNeedsLayout()
	}
	
}
