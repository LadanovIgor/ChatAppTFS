//
//  ConversationsListTableHeaderView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationsListTableHeaderView: UITableViewHeaderFooterView {
	
	// MARK: - Outlets and Properties
	
	static let preferredHeight: CGFloat = 50
	static let identifier = "ConversationsListTableHeaderView"
	
	private let addButton = TouchAnimateButton()
	
	var addingChannel: (() -> Void)?
	
	// MARK: - Init
	
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
	
	// MARK: - Private
	
	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
			addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
		])
	}
	
	private func setUpButton() {
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.setImage(UIImage(named: "chatNew"), for: .normal)
		addButton.addTarget(self, action: #selector(didAddButtonTapped), for: .touchUpInside)
		addButton.clipsToBounds = true
		contentView.addSubview(addButton)
	}
	
	@objc private func didAddButtonTapped() {
		addingChannel?()
	}
}
