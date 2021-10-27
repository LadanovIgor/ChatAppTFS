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
		NSLayoutConstraint.activate([
			addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			addButton.heightAnchor.constraint(equalToConstant: 30),
			addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
		])
	}
	
	private func setUpButton() {
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.setImage(UIImage(named: "add"), for: .normal)
//		let attributedTitle = NSAttributedString(string: "+",
//												 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .regular)])
//		addButton.setAttributedTitle(attributedTitle, for: .normal)
		addButton.addTarget(self, action: #selector(didAddButtonTapped), for: .touchUpInside)
		addButton.clipsToBounds = true
		contentView.addSubview(addButton)
	}
	
	@objc private func didAddButtonTapped() {
		addingChannel?()
	}
}
