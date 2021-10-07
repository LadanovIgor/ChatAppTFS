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
	private var bottomConstraint: NSLayoutConstraint?

	private var messages: [Message]
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	init(messages: [Message]) {
		self.messages = messages
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setUpBackButton()
		setUpTableView()
		setUpNewMessageView()
		setUpConstraints()
		addKeyboardObservers()
		navigationController?.navigationBar.backgroundColor = .white
	}
	
	
	private func setUpNewMessageView() {
		newMessageView.backgroundColor = UIColor(named: "lightGray") ?? .gray
		view.addSubview(newMessageView)
		newMessageView.translatesAutoresizingMaskIntoConstraints = false
	}

	private func addKeyboardObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)),
											   name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)),
											   name: UIResponder.keyboardWillHideNotification, object: nil)

	}
	
	@objc private func handleKeyboardNotification(notification: NSNotification) {
		guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		let keyboardHeight = keyboardFrame.cgRectValue.height
		let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
		bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
		UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
			self.view.layoutIfNeeded()
		} completion: { [weak self] _ in
			guard let self = self else { return }
			if isKeyboardShowing, self.messages.count > 0 {
				let indexPath = IndexPath(row: self.messages.count-1, section: 0)
				self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
			}
		}
	}
	
	private func setUpBackButton() {
		let backButton = UIBarButtonItem()
		backButton.title = "Back"
		backButton.tintColor = UIColor(named: "buttonTitle") ?? .blue
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
		let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
		let views = ["tableView": tableView, "newMessageView": newMessageView]
		let metrics = ["viewHeight": 80, "top": statusBarHeight]
		
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|-top-[tableView][newMessageView(viewHeight)]",
			metrics: metrics,
			views: views))
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[newMessageView]|",
			metrics: metrics,
			views: views))
		
		bottomConstraint = NSLayoutConstraint(item: newMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		guard let constraint = bottomConstraint else {
			return
		}
		view.addConstraint(constraint)
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
		cell.configure(with: .init(model: message))
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
}

    

