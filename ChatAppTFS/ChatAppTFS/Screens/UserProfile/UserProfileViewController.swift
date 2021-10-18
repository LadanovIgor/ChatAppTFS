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
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var infoTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var cancelButton: UIButton!
	
	@IBOutlet var infoTextFieldTopConstraint: NSLayoutConstraint!
	@IBOutlet var saveButtonBottomConstraint: NSLayoutConstraint!
	@IBOutlet var nameTextFieldTopConstraint: NSLayoutConstraint!
	
	private let imagePicker = UIImagePickerController()
	
	private var isProfileEditing: Bool = false {
		didSet {
			updateScreenLayoutDependingOn(isEditing: isProfileEditing)
		}
	}
	
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
		nameTextField.delegate = self
		locationTextField.delegate = self
		infoTextField.delegate = self
	}
	
	private func setUpSaveButton() {
		saveGCDButton.layer.cornerRadius = Constants.ProfileScreen.buttonCornerRadius
		saveOperationButton.layer.cornerRadius = Constants.ProfileScreen.buttonCornerRadius
		cancelButton.layer.cornerRadius = Constants.ProfileScreen.buttonCornerRadius
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
			infoTextFieldTopConstraint.constant = Constants.ProfileScreen.nameInfoOffset * 2
		} else {
			infoTextFieldTopConstraint.constant = Constants.ProfileScreen.nameInfoOffset
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
		present(actionSheet, animated: true)
	}
	
	@objc private func didCancelButtonTapped() {
		isProfileEditing = false
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
		isProfileEditing = true
		self.nameTextField.becomeFirstResponder()
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
	
	private func updateScreenLayoutDependingOn(isEditing: Bool) {
		saveOperationButton.isHidden = !isEditing
		saveGCDButton.isHidden = !isEditing
		editProfileButton.isHidden = isEditing
		cancelButton.isHidden = !isEditing
		nameTextField.isEnabled = isEditing
		locationTextField.isEnabled = isEditing
		infoTextField.isEnabled = isEditing
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
		KeyboardObserver.shared.startObserving { [weak self] keyboardHeight, isKeyboardShowing in
			self?.saveButtonBottomConstraint?.constant = isKeyboardShowing ? keyboardHeight : 0
			self?.nameTextFieldTopConstraint.isActive = !isKeyboardShowing
			UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				self?.profileImageView.isHidden = isKeyboardShowing
				self?.view.layoutIfNeeded()
			}
		}
	}
	
	deinit {
		KeyboardObserver.shared.stopObserving()
	}
}

	// MARK: - UIImagePickerController

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imagePicker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
			  let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
			return
		}
		profileImageView.image = image
		editProfileButton.isHidden = true
		saveOperationButton.isHidden = false
		saveGCDButton.isHidden = false
		cancelButton.isHidden = false
	}
}

extension UserProfileViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.isFirstResponder {
			textField.text = textField.placeholder
			textField.placeholder = nil
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.placeholder = textField.text
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let textFieldText = textField.text,
			let rangeOfText = Range(range, in: textFieldText) else {
				return false
		}
		let count = textFieldText.count - textFieldText[rangeOfText].count + string.count
		if textField == nameTextField {
			return count <= Constants.ProfileScreen.nameCharacters
		} else {
			return count <= Constants.ProfileScreen.infoCharacters
		}
	}
}
