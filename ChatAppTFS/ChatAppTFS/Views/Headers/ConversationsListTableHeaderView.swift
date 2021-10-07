//
//  ConversationsListTableHeaderView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationsListTableHeaderView: UITableViewHeaderFooterView {
	
	static let identifier = "ConversationsListTableHeaderView"
	static let preferredHeight: CGFloat = 40

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .clear
		contentView.tintColor = UIColor(named: "buttonTitle") ?? .blue
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
