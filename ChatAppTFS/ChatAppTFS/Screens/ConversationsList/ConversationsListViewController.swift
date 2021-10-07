//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
	
	// MARK: - Properties
	
	private let usersOnline: [User] = [
		User(name: "Homer Simpson", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		]),
		User(name: "Marge Simpson", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Lisa Simpson", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Abraham Simpson", isOnline: true, messages: nil),
		User(name: "Milhouse Van Houten", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Mr. Burns", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		]),
		User(name: "Philip J. Fry", isOnline: true, messages: nil),
		User(name: "Hubert J. Farnsworth", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Dr. Amy Wong", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Zapp Brannigan", isOnline: true, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		])
	]
	
	private let usersOffline: [User] = [
		User(name: "Bart Simpson", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Maggie Simpson", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		]),
		User(name: "Apu Nahasapeemapetilon", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		]),
		User(name: "Chief Clancy Wiggum", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		]),
		User(name: "Turanga Leela", isOnline: false, messages: nil),
		User(name: "Bender Bending Rodríguez", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Lord Nibbler", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false)
		]),
		User(name: "Turanga Leela", isOnline: false, messages: nil),
		User(name: "Kif Kroker", isOnline: false, messages: [
			Message(text: "Morning! The last episode was awesome",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "Thx, I try my best",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Matty, I'm very exhausted, I wanna go on vacation to the Caribbean",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: false),
			Message(text: "We're overwhelmed now, be patient",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: true, isSelfMessage: true),
			Message(text: "Hey Matt. I don't think my character's storyline has any progression. How about my running for president of the US?",
					date: Date.randomBetween(start: Date(timeIntervalSinceNow: -3600*24*4), end: Date()), isRead: false, isSelfMessage: false)
		]),
		User(name: "Turanga Leela", isOnline: false, messages: nil)
	]
	
	private var tableView = UITableView(frame: .zero, style: .grouped)

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.init(named: "backgroundColor") ?? .white
		title = "Tinkoff Chat"
		setUpTableView()
		setUpRightBarItem()
	}
	
	// MARK: - Private

	private func setUpRightBarItem() {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "userPlaceholder")
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.layer.masksToBounds = true
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
		button.setImage(UIImage(named: "userPlaceholder"), for: .normal)
		button.clipsToBounds = true
		button.layer.masksToBounds = true
		button.backgroundColor = .red
		button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
		NSLayoutConstraint.activate([
			button.widthAnchor.constraint(equalToConstant: 32),
			button.heightAnchor.constraint(equalToConstant: 32)
		])
		button.round()
	}
	
	@objc private func didTapRightBarButton() {
		present(UserProfileViewController(), animated: true)
	}

	private func setUpTableView() {
		tableView.separatorStyle = .none
		tableView.backgroundColor = .white
		tableView.register(
			ConversationsListTableViewCell.nib,
			forCellReuseIdentifier: ConversationsListTableViewCell.name)
		tableView.register(
			ConversationsListTableHeaderView.self,
			forHeaderFooterViewReuseIdentifier: ConversationsListTableHeaderView.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addConstraints(NSLayoutConstraint.constraints(
			withNewVisualFormat: "H:|[tableView]|,V:|[tableView]|",
			metrics: nil,
			views: ["tableView":tableView]))
	}
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
			case 0: return "Online"
			case 1: return "History"
			default: return ""
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return ConversationsListTableViewCell.preferredHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		switch indexPath.section {
			case 0:
				let vc = ConversationViewController(messages: usersOnline[indexPath.row].messages ?? [])
				vc.title = usersOnline[indexPath.row].name
				navigationController?.pushViewController(vc, animated: true)
			case 1:
				let vc = ConversationViewController(messages: usersOffline[indexPath.row].messages ?? [])
				vc.title = usersOffline[indexPath.row].name
				navigationController?.pushViewController(vc, animated: true)
			default: break
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return ConversationsListTableHeaderView.preferredHeight
	}
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0: return usersOnline.count
			case 1: return usersOffline.count
			default: return 2
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ConversationsListTableViewCell.name,
			for: indexPath) as? ConversationsListTableViewCell else {
				return UITableViewCell()
			}
		var model: User
		switch indexPath.section {
			case 0: model = usersOnline[indexPath.row]
			case 1: model = usersOffline[indexPath.row]
			default: model = usersOnline[indexPath.row]
		}
		cell.configure(with: .init(model: model))
		cell.layoutIfNeeded()
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		 guard let view = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: ConversationsListTableHeaderView.identifier) as? ConversationsListTableHeaderView else {
			return UIView()
		}
		return view
		
	}
	
}
