//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class UserProfileViewController: UIViewController, UIGestureRecognizerDelegate {
	
	// MARK: - Outlets and Properties
	
	@IBOutlet weak var profileImageView: CircleImageView!
	@IBOutlet weak var closeProfileButton: UIButton!
	@IBOutlet weak var editProfileButton: UIButton!
	@IBOutlet weak var saveGCDButton: UIButton!
	@IBOutlet weak var saveOperationButton: UIButton!
	@IBOutlet weak var fullNameTextField: UITextField!
	@IBOutlet weak var selfInformationTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var cancelButton: UIButton!
	
	@IBOutlet var informationTopConstraint: NSLayoutConstraint!
	@IBOutlet var saveButtonBottomConstraint: NSLayoutConstraint!
	@IBOutlet var fullNameTopToImageViewConstraint: NSLayoutConstraint!
	
	private let imagePicker = UIImagePickerController()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpSaveButton()
		addButtonTargets()
		setUpProfileImageView()
		delegating()
		setUpConstraints()
		addKeyboardObservers()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		profileImageView.round()
		profileImageView.layer.masksToBounds = true
	}
	
	// MARK: - Private
	
	private func delegating() {
		imagePicker.delegate = self
		fullNameTextField.delegate = self
		locationTextField.delegate = self
		selfInformationTextField.delegate = self
	}
	
	private func setUpSaveButton() {
		saveGCDButton.layer.cornerRadius = 14.0
		saveOperationButton.layer.cornerRadius = 14.0
		cancelButton.layer.cornerRadius = 14.0
	}
	
	private func setUpProfileImageView() {
		profileImageView.clipsToBounds = true
		profileImageView.contentMode = .scaleAspectFill
		profileImageView.isUserInteractionEnabled = true
		profileImageView.clipsToBounds = true
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didProfileImageViewTapped))
		profileImageView.addGestureRecognizer(gesture)
		guard let image = UIImage(named: "userPlaceholder") else {
			return
		}
		profileImageView.image = image
	}
	
	private func setUpConstraints() {
		if #available(iOS 13, *) {
			fullNameTopToImageViewConstraint.constant = 32
			informationTopConstraint.constant = 16
		} else {
			fullNameTopToImageViewConstraint.constant = 16
			informationTopConstraint.constant = 3
		}
	}
	
	private func addButtonTargets() {
		saveGCDButton.addTarget(self, action: #selector(didSaveGCDButtonTapped), for: .touchUpInside)
		editProfileButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
		closeProfileButton.addTarget(self, action: #selector(didCloseButtonTapped), for: .touchUpInside)
		saveOperationButton.addTarget(self, action: #selector(didSaveOperationButtonTapped), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(didCancelButtonTapped), for: .touchUpInside)

	}
	
	@objc private func didProfileImageViewTapped() {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: {[weak self] _ in
			self?.choosePhotoFromGallery()
		}))
		actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: {[weak self] _ in
			self?.useCameraForPhoto()
		}))
		actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
		present(actionSheet, animated: true, completion: nil)
	}
	
	@objc private func didCancelButtonTapped() {
		self.fullNameTextField.isEnabled = false
		self.locationTextField.isEnabled = false
		self.selfInformationTextField.isEnabled = false
	}
	
	@objc private func didSaveGCDButtonTapped() {
		activityStartedAnimation()
		// Save profile
	}
	
	@objc private func didSaveOperationButtonTapped() {
		activityStartedAnimation()
		// Save profile
	}
	
	@objc private func didEditButtonTapped() {
		self.fullNameTextField.isEnabled = true
		self.locationTextField.isEnabled = true
		self.selfInformationTextField.isEnabled = true
		self.fullNameTextField.becomeFirstResponder()
	}
	
	@objc private func didCloseButtonTapped() {
		dismiss(animated: true, completion: nil)
	}
	
	private func activityStartedAnimation() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}
	
	private func activityFinishedAnimation() {
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
	}
	
	private func useCameraForPhoto() {
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			let alert = UIAlertController(title: "Warning!", message: "Camera not found", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		imagePicker.sourceType = .camera
		present(imagePicker, animated: true)
	}
	
	private func choosePhotoFromGallery() {
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true, completion: nil)
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
		saveButtonBottomConstraint?.constant = isKeyboardShowing ? keyboardHeight : 0
		fullNameTopToImageViewConstraint.isActive = !isKeyboardShowing
		UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
			self.profileImageView.isHidden = isKeyboardShowing
			self.view.layoutIfNeeded()
		} completion: { [weak self] _ in
			guard let self = self else { return }
			self.saveOperationButton.isHidden = !isKeyboardShowing
			self.saveGCDButton.isHidden = !isKeyboardShowing
			self.editProfileButton.isHidden = isKeyboardShowing
			self.cancelButton.isHidden = !isKeyboardShowing
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
	}
	
}

	// MARK: - UIImagePickerController

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imagePicker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			return
		}
		profileImageView.image = image
	}
}

extension UserProfileViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.isFirstResponder {
			textField.placeholder = nil
		}
	}
}
