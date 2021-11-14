//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
	
	// MARK: - Properties
	
	var presenter: ConversationsListPresenter?
	let tableView = UITableView(frame: .zero, style: .plain)
	let leftBarButton = UIButton()
	let rightBarButton = UIButton()
	
	private let barButtonSize = Constants.ConversationListScreen.barButtonSize
	
	convenience init(presenter: ConversationsListPresenter) {
		self.init()
		self.presenter = presenter
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Channels"
		presenter?.viewDidLoad()
		addTargets()
		setUpTableView()
		setUpRightBarItem()
		setUpLeftBarItem()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		rightBarButton.round()
	}
	
	// MARK: - Private
	
	private func setUpLeftBarItem() {
		let image = UIImage(named: "themes")
		leftBarButton.setImage(image, for: .normal)
		leftBarButton.clipsToBounds = true
		leftBarButton.layer.masksToBounds = true
		leftBarButton.backgroundColor = .clear
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
	}

	private func setUpRightBarItem() {
		let resizeImage = UIImage.textImage(text: "FN")?.resize(width: barButtonSize, height: barButtonSize)
		rightBarButton.setImage(resizeImage, for: .normal)
		rightBarButton.clipsToBounds = true
		rightBarButton.layer.masksToBounds = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
		presenter?.getUserName { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let text):
					guard let image = UIImage.textImage(text: text.getCapitalLetters()) else {
						return
					}
					self.rightBarButton.setImage(image.resize(width: self.barButtonSize, height: self.barButtonSize), for: .normal)
				case .failure: break
			}
		}
	}
	
	private func setUpTableView() {
		tableView.showsVerticalScrollIndicator = false
		tableView.separatorStyle = .none
		tableView.register(
			ConversationsListTableViewCell.nib,
			forCellReuseIdentifier: ConversationsListTableViewCell.name)
		tableView.register(
			ConversationsListTableHeaderView.self,
			forHeaderFooterViewReuseIdentifier: ConversationsListTableHeaderView.identifier)
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView]|",
			metrics: nil,
			views: ["tableView": tableView]))
	}
	
	private func addTargets() {
		leftBarButton.addTarget(self, action: #selector(didTapLeftBarButton), for: .touchUpInside)
		rightBarButton.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
	}
	
	@objc private func didTapLeftBarButton() {
		presenter?.leftBarButtonTapped()
	}
	
	@objc private func didTapRightBarButton() {
		presenter?.rightBarButtonTapped()
	}
	
	func presentCreateChannelAlert() {
		var textField = UITextField()
		let alert = UIAlertController(title: "New channel", message: nil, preferredStyle: .alert)
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Channel name"
			textField = alertTextField
		}
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
			guard let channelName = textField.text, !channelName.isEmpty else {
				return
			}
			self?.presenter?.createNewChannel(with: channelName)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
}
