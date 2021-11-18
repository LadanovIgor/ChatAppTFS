//
//  NewMessageView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class SendMessageView: UIView {
	
	// MARK: - Properties

	private var textField = UITextField()
	private var sendButton = UIButton()
	
	var messageSent: ((String) -> Void)?
		
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		addSubViews(textField, sendButton)
		setUpSendButton()
		setUpTextField()
		setUpConstraints()
	}
	
	// MARK: - Private
	
	private func setUpSendButton() {
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
		let attributedString = NSAttributedString(
			string: "Send",
			attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
						 NSAttributedString.Key.foregroundColor: UIColor(named: "buttonTitle") ?? .blue])
		sendButton.setAttributedTitle(attributedString, for: .normal)
	}
	
	private func setUpTextField() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "  You message here..."
		textField.delegate = self
		textField.font = .systemFont(ofSize: 17, weight: .regular)
		textField.textAlignment = .left
		textField.textColor = .black
		textField.layer.masksToBounds = true
		textField.layer.cornerRadius = Constants.SendMessageView.textFieldCornerRadius
		textField.layer.borderColor = UIColor.gray.cgColor
		textField.layer.borderWidth = Constants.SendMessageView.textFieldBorderWidth
	}
	
	private func setUpConstraints() {
		let metrics = ["offset": Constants.SendMessageView.offset, "width": Constants.SendMessageView.sendButtonWidth ]
		let views = ["textField": textField, "button": sendButton]
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-offset-[textField]-offset-[button(width)]-offset-|",
			options: [.alignAllCenterY],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-offset-[button]-offset-|",
			options: [],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-offset-[textField]-offset-|",
			options: [],
			metrics: metrics,
			views: views))
	}
	
	@objc private func didTapSendButton() {
		if let text = textField.text, !text.isEmpty {
			messageSent?(text)
		}
		textField.endEditing(true)
		textField.text = nil
	}
	
	// MARK: - Public
	
	public func stopEditing() {
		textField.endEditing(true)
		textField.text = nil
	}
}

	// MARK: - UITextFieldDelegate

extension SendMessageView: UITextFieldDelegate {
	
}