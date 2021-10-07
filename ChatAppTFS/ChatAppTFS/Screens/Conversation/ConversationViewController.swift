//
//  ConversationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationViewController: UIViewController {

	private let tableView = UITableView(frame: .zero, style: .grouped)
	private let newMessageView = NewMessageView()

	private var messages: [Message]
	
	init(messages: [Message]) {
		self.messages = messages
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setUpBackButton()
		setUpTableView()
		setUpNewMessageView()
		setUpConstraints()
		navigationController?.navigationBar.backgroundColor = .white
	}
	
	
	private func setUpNewMessageView() {
		newMessageView.backgroundColor = .gray
		newMessageView.layer.borderWidth = 1
		newMessageView.layer.borderColor = UIColor.black.cgColor
		view.addSubview(newMessageView)
		newMessageView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func setUpBackButton() {
		let backButton = UIBarButtonItem()
		backButton.title = "Back"
		backButton.tintColor = .black
		navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
	}

	private func setUpTableView() {
		tableView.separatorStyle = .none
		tableView.backgroundColor = .white
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ConversationTableViewCell.self,
						   forCellReuseIdentifier: ConversationTableViewCell.identifier)
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
	}
	
	private func setUpConstraints() {
		view.removeConstraints(view.constraints)
		let navBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
		let views = ["tableView": tableView, "newMessageView": newMessageView]
		let metrics = ["viewHeight": 80, "top": navBarHeight]
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|-top-[tableView][newMessageView(viewHeight)]|",
			metrics: metrics,
			views: views))
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[newMessageView]|",
			metrics: metrics,
			views: views))
		
	}
}

extension ConversationViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		newMessageView.stopEditing()
	}
}

extension ConversationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationTableViewCell.identifier,
			for: indexPath) as? ConversationTableViewCell else {
				return UITableViewCell()
			}
		let message = messages[indexPath.row]
		cell.configure(with: message.text, date: message.date, isSelfMessage: message.isSelfMessage)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
}

    

