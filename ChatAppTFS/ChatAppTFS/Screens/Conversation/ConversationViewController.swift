//
//  ConversationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class ConversationViewController: UIViewController, KeyboardObservable {
	
	// MARK: - Properties
	
	var controller: ConversationController?
	
	let tableView = UITableView(frame: .zero, style: .grouped)
	let sendMessageView = SendMessageView()
	var bottomConstraint: NSLayoutConstraint?
	
	// MARK: - Init
	
	convenience init(controller: ConversationController) {
		self.init()
		self.controller = controller
	}
	
	deinit {
		stopObserving()
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		controller?.viewDidLoad()
		setUpBackButton()
		setUpTableView()
		setUpSendMessageView()
		setUpConstraints()
		addKeyboardObservers()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
	}
	
	// MARK: - Private
	
	private func setUpSendMessageView() {
		view.addSubview(sendMessageView)
		sendMessageView.translatesAutoresizingMaskIntoConstraints = false

	}

	private func addKeyboardObservers() {
		startObserving { [weak self] keyboardHeight, isKeyboardShowing in
			self?.bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
			UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				self?.view.layoutIfNeeded()
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
		tableView.register(ConversationTableViewCell.nib,
						   forCellReuseIdentifier: ConversationTableViewCell.name)
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
	}
	
	private func setUpConstraints() {
		view.removeConstraints(view.constraints)
		let statusBarHeight = UIApplication.shared.statusBarFrame.height
		let views = ["tableView": tableView, "newMessageView": sendMessageView]
		let metrics = ["viewHeight": Constants.ConversationScreen.messageViewHeight,
					   "offset": statusBarHeight
		]
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|-offset-[tableView][newMessageView(viewHeight)]",
			metrics: metrics,
			views: views))
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[newMessageView]|",
			metrics: metrics,
			views: views))
		bottomConstraint = NSLayoutConstraint(item: sendMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		guard let constraint = bottomConstraint else {
			return
		}
		view.addConstraint(constraint)
	}	
}
