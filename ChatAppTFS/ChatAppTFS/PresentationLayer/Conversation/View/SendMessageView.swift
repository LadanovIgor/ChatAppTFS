//
//  NewMessageView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import UIKit

protocol SendMessageDelegate: AnyObject {
	func didTappedPresentPictures(completion: @escaping (String) -> Void)
}

class SendMessageView: UIView {
	
	// MARK: - Properties

	private let textField = UITextField()
	private let sendButton = UIButton()
	private let picturesButton = UIButton()
	
	var messageSent: ((String) -> Void)?
	
	weak var delegate: SendMessageDelegate?
		
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		addSubViews(textField, sendButton, picturesButton)
		setUpSendButton()
		setUpTextField()
		setUpConstraints()
		setUpPictureButton()
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
	
	private func setUpPictureButton() {
		picturesButton.translatesAutoresizingMaskIntoConstraints = false
		picturesButton.addTarget(self, action: #selector(didTapPicturesButton), for: .touchUpInside)
		let image = UIImage(named: "themes")
		picturesButton.setImage(image, for: .normal)
		picturesButton.clipsToBounds = true
		picturesButton.layer.masksToBounds = true
		picturesButton.backgroundColor = .clear
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
		let views = ["textField": textField, "send": sendButton, "pictures": picturesButton]
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-offset-[pictures(50)]-offset-[textField]-offset-[send(width)]-offset-|",
			options: [.alignAllCenterY],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-offset-[send]-offset-|",
			options: [],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-offset-[textField]-offset-|",
			options: [],
			metrics: metrics,
			views: views))
		addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-offset-[pictures]-offset-|",
			options: [],
			metrics: metrics,
			views: views))
	}
	
	@objc private func didTapPicturesButton() {
		delegate?.didTappedPresentPictures { [weak self] text in
			self?.textField.text = text
		}
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
