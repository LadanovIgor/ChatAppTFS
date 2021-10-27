//
//  ConversationsListTableHeaderView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationsListTableHeaderView: UITableViewHeaderFooterView {
	
	static let preferredHeight: CGFloat = 40
	static let identifier = "ConversationsListTableHeaderView"
	
	private let addButton = UIButton()
	
	var addingChannel: (() -> Void)?
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setUpButton()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		setUpConstraints()
	}
	
	private func setUpConstraints() {
		addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
	}
	
	private func setUpButton() {
		addButton.translatesAutoresizingMaskIntoConstraints = false
		let attributedTitle = NSAttributedString(string: "Create",
												 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
		addButton.setAttributedTitle(attributedTitle, for: .normal)
		addButton.addTarget(self, action: #selector(didAddButtonTapped), for: .touchUpInside)
		contentView.addSubview(addButton)
	}
	
	@objc private func didAddButtonTapped() {
		addingChannel?()
	}
}
