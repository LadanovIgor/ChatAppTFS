//
//  NewMessageView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

class NewMessageView: UIView {

	private var textField = UITextField()
	private var sendButton = UIButton()
		
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		addSubViews(textField, sendButton)
		setUpAddButton()
		setUpTextField()
		setUpConstraints()
	}
	
	private func setUpAddButton() {
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
		let attributedString = NSAttributedString(
			string: "Send",
			attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(named: "buttonTitle") ?? .blue])
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
		textField.layer.cornerRadius = 11
		textField.layer.borderColor = UIColor.gray.cgColor
		textField.layer.borderWidth = 0.3
	}
	
	private func setUpConstraints() {
		let metrics = ["padding": 18, ]
		let views = ["textField": textField, "button": sendButton]
		textField.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-padding-[textField]-padding-[button]-padding-|",
			options: [.alignAllCenterY],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-padding-[button]-padding-|",
			options: [],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-padding-[textField]-padding-|",
			options: [],
			metrics: metrics,
			views: views))
	}
	
	@objc private func didTapSendButton() {
		textField.endEditing(true)
		textField.text = nil
	}
	
	public func stopEditing() {
		textField.endEditing(true)
		textField.text = nil
	}
}

extension NewMessageView: UITextFieldDelegate {

}
