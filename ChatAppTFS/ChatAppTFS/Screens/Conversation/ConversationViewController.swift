//
//  ConversationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationViewController: UIViewController {
	
	// MARK: - Properties

	private let tableView = UITableView(frame: .zero, style: .grouped)
	private let newMessageView = NewMessageView()
	private var bottomConstraint: NSLayoutConstraint?
	private var messages: [Message]
	
	// MARK: - Init
	
	init(messages: [Message]) {
		self.messages = messages
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		KeyboardObserver.shared.stopObserving()
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpBackButton()
		setUpTableView()
		setUpNewMessageView()
		setUpConstraints()
		addKeyboardObservers()
	}
	
	// MARK: - Private
	
	private func setUpNewMessageView() {
		view.addSubview(newMessageView)
		newMessageView.translatesAutoresizingMaskIntoConstraints = false
	}

	private func addKeyboardObservers() {
		KeyboardObserver.shared.startObserving { [weak self] keyboardHeight, isKeyboardShowing in
			self?.bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
			UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				self?.view.layoutIfNeeded()
			} completion: { [weak self] _ in
				guard let self = self else { return }
				if isKeyboardShowing, self.messages.count > 0 {
					let indexPath = IndexPath(row: self.messages.count-1, section: 0)
					self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
				}
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
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ConversationTableViewCell.self,
						   forCellReuseIdentifier: ConversationTableViewCell.identifier)
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
	}
	
	private func setUpConstraints() {
		view.removeConstraints(view.constraints)
		let views = ["tableView": tableView, "newMessageView": newMessageView]
		let metrics = ["viewHeight": Constants.ConversationScreen.messageViewHeight]
		
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView][newMessageView(viewHeight)]",
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

	// MARK: - UITableViewDelegate and UITableViewDataSource

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

    

