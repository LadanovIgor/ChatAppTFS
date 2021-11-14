//
//  UserProfileController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

//import Foundation
//
//class UserProfileController: NSObject, UIGestureRecognizerDelegate {
//	weak var viewController: UserProfileViewController?
//	private var changedValues = [String: Data]()
//	private var loadedValues = [String: Data]()
//
//
//
//	private func delegating() {
//		viewController?.imagePicker.delegate = self
//		viewController?.nameTextField.delegate = self
//		viewController?.locationTextField.delegate = self
//		viewController?.infoTextField.delegate = self
//	}
//
//	private func addButtonTargets() {
//		viewController?.saveButton.addTarget(self, action: #selector(didSaveButtonTapped), for: .touchUpInside)
//		viewController?.editProfileButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
//		viewController?.closeProfileButton.addTarget(self, action: #selector(didCloseButtonTapped), for: .touchUpInside)
//		viewController?.cancelButton.addTarget(self, action: #selector(didCancelButtonTapped), for: .touchUpInside)
//		viewController?.locationTextField.addTarget(self, action: #selector(didTextFieldDidChange), for: .editingChanged)
//		viewController?.infoTextField.addTarget(self, action: #selector(didTextFieldDidChange), for: .editingChanged)
//		viewController?.nameTextField.addTarget(self, action: #selector(didTextFieldDidChange), for: .editingChanged)
//	}
//
//	func set(viewController: UserProfileViewController) {
//		self.viewController = viewController
//	}
//
//
//	private func saveProfile() {
//		viewController?.activityStartedAnimation()
//		viewController?.changeButtonState(with: false)
//		LocalStorageManager.shared.saveLocally(changedValues) { [weak self] result in
//			self?.viewController?.activityFinishedAnimation()
//			switch result {
//			case .success:
//				self?.viewController?.presentSuccessLoadAlert()
//				self?.updateValues(with: self?.changedValues)
//			case .failure:
//				self?.viewController?.presentFailureLoadAlert(handler: self?.saveProfile)
//			}
//		}
//	}
//
//	private func updateValues(with values: [String: Data]?) {
//		guard let values = values else {
//			return
//		}
//		for key in values.keys {
//			loadedValues[key] = values[key]
//		}
//		changedValues = [String: Data]()
//	}
//
//	private func updateScreen(with values: [String: Data]) {
//		DispatchQueue.global(qos: .userInteractive).async {
//			let nameText: String
//			let infoText: String
//			let locationText: String
//			if let nameData = values[Constants.LocalStorage.nameKey], let name = String(data: nameData, encoding: .utf8) {
//				nameText = name
//			} else {
//				nameText = "Full name"
//			}
//			if let infoData = values[Constants.LocalStorage.infoKey], let info = String(data: infoData, encoding: .utf8) {
//				infoText = info
//			} else {
//				infoText = "About youself"
//			}
//			if let locationData = values[Constants.LocalStorage.locationKey], let location = String(data: locationData, encoding: .utf8) {
//				locationText = location
//			} else {
//				locationText = "Location"
//			}
//			let imageData = values[Constants.LocalStorage.imageKey]
//			DispatchQueue.main.async { [weak self] in
//				self?.viewController?.nameTextField.text = nameText
//				self?.viewController?.locationTextField.text = locationText
//				self?.viewController?.infoTextField.text = infoText
//				self?.viewController?.updateProfileImageView(with: imageData)
//			}
//		}
//	}
//
//	private func updateProfileImageView(with data: Data?) {
//		guard let data = data, let image = UIImage(data: data) else {
//			let capitalLetters = viewController?.nameTextField.text?.getCapitalLetters()
//			viewController?.profileImageView.image = UIImage.textImage(text: capitalLetters)
//			return
//		}
//		viewController?.profileImageView.image = image
//	}
//
//	private func fetchProfileData() {
//		viewController?.activityStartedAnimation()
//		LocalStorageManager.shared.loadLocally { [weak self] result in
//			switch result {
//			case .success(let dict):
//				self?.loadedValues = dict
//				self?.updateScreen(with: dict)
//			case .failure(let error):
//				print(error.localizedDescription)
//			}
//			self?.viewController?.activityFinishedAnimation()
//		}
//	}
//
//	private func addGesture() {
//		viewController?.profileImageView.isUserInteractionEnabled = true
//		let gesture = UITapGestureRecognizer(target: self, action: #selector(didProfileImageViewTapped))
//		viewController?.profileImageView.addGestureRecognizer(gesture)
//	}
//
//	@objc private func didProfileImageViewTapped() {
//		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//		actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: {[weak self] _ in
//			self?.choosePhotoFromGallery()
//		}))
//		actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: {[weak self] _ in
//			self?.useCameraForPhoto()
//		}))
//		actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//		present(actionSheet, animated: true)
//	}
//
//	@objc private func didCancelButtonTapped() {
//		updateScreen(with: loadedValues)
//		viewController?.isProfileEditing = false
//	}
//
//	@objc private func didSaveButtonTapped(_ button: UIButton) {
//		viewController?.locationTextField.resignFirstResponder()
//		viewController?.infoTextField.resignFirstResponder()
//		viewController?.nameTextField.resignFirstResponder()
//		guard !changedValues.isEmpty else { return }
//		saveProfile()
//	}
//
//	@objc private func didEditButtonTapped() {
//		viewController?.cancelButton.isEnabled = true
//		viewController?.isProfileEditing = true
//		viewController?.nameTextField.becomeFirstResponder()
//	}
//
//	@objc private func didCloseButtonTapped() {
//		viewController?.dismiss(animated: true, completion: nil)
//	}
//
//	@objc private func didTextFieldDidChange() {
//		viewController?.saveButton.isEnabled = true
//	}
//
//	private func useCameraForPhoto() {
//		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//			let alert = UIAlertController(title: "Warning!", message: "Camera not found", preferredStyle: .alert)
//			alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//			present(alert, animated: true, completion: nil)
//			return
//		}
//		viewController?.imagePicker.sourceType = .camera
//		present(viewController?.imagePicker, animated: true)
//	}
//
//	private func choosePhotoFromGallery() {
//		viewController?.imagePicker.sourceType = .photoLibrary
//		present(viewController?.imagePicker, animated: true, completion: nil)
//	}
//}
//
//// MARK: - UIImagePickerController
//
//extension UserProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//	imagePicker.dismiss(animated: true, completion: nil)
//	guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
//		return
//	}
//	viewController?.profileImageView.image = image
//	viewController?.editProfileButton.isHidden = true
//	viewController?.saveButton.isHidden = false
//	viewController?.cancelButton.isHidden = false
//	viewController?.changeButtonState(with: true)
//	guard let imageData = image.jpegData(compressionQuality: 1.0) else {
//		return
//	}
//	changedValues[Constants.LocalStorage.imageKey] = imageData
//}
//}
