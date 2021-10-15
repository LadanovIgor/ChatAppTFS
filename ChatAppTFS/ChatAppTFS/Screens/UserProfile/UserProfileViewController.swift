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
	@IBOutlet weak var cancelButton: UIButton!

	
	private let imagePicker = UIImagePickerController()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpSaveButton()
		addButtonTargets()
		setUpProfileImageView()
		delegating()
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
	
	private func addButtonTargets() {
		saveGCDButton.addTarget(self, action: #selector(didSaveGCDButtonTapped), for: .touchUpInside)
		editProfileButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
		closeProfileButton.addTarget(self, action: #selector(didCloseButtonTapped), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(didCancelButtonTapped), for: .touchUpInside)
		saveOperationButton.addTarget(self, action: #selector(didSaveOperationButtonTapped), for: .touchUpInside)
	}
	
	@objc private func didProfileImageViewTapped() {
		print("Выбери изображение профиля")
		
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
		editProfileButton.isHidden = false
		cancelButton.isHidden = true
		fullNameTextField.isEnabled = false
		locationTextField.isEnabled = false
		selfInformationTextField.isEnabled = false
		saveOperationButton.isEnabled = false
		saveOperationButton.isHidden = true
		saveGCDButton.isEnabled = false
		saveGCDButton.isHidden = true
	}
	
	@objc private func didSaveGCDButtonTapped() {
		// Save profile
	}
	
	@objc private func didSaveOperationButtonTapped() {
		// Save profile
	}
	
	@objc private func didEditButtonTapped() {
		saveOperationButton.isHidden = false
		saveGCDButton.isHidden = false
		editProfileButton.isHidden = true
		cancelButton.isHidden = false
		fullNameTextField.isEnabled = true
		locationTextField.isEnabled = true
		selfInformationTextField.isEnabled = true
		fullNameTextField.becomeFirstResponder()
	}
	
	@objc private func didCloseButtonTapped() {
		dismiss(animated: true, completion: nil)
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
