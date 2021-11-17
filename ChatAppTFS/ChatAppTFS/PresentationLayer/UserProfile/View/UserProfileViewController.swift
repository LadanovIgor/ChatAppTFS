//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class UserProfileViewController: UIViewController, UIGestureRecognizerDelegate, KeyboardObservable {

	// MARK: - Outlets and Properties
	
	@IBOutlet weak var profileImageView: CircleImageView!
	@IBOutlet weak var closeProfileButton: UIButton!
	@IBOutlet weak var editProfileButton: UIButton!
	@IBOutlet weak var saveButton: AppButton!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var infoTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var cancelButton: AppButton!
	@IBOutlet var infoTextFieldTopConstraint: NSLayoutConstraint!
	@IBOutlet var saveButtonBottomConstraint: NSLayoutConstraint!
	@IBOutlet var nameTextFieldTopConstraint: NSLayoutConstraint!
	
	private let imagePicker = UIImagePickerController()
	private var presenter: ProfilePresenterProtocol?
	
	private var isProfileEditing: Bool = false {
		didSet {
			updateScreenLayoutDependingOn(isEditing: isProfileEditing)
		}
	}
	
	// MARK: - Init
	
	convenience init(presenter: ProfilePresenterProtocol) {
		self.init()
		self.presenter = presenter
	}
	
	deinit {
		stopObserving()
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter?.viewDidLoad()
		setUpSaveButton()
		addTargets()
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
		saveButton.layer.cornerRadius = Constants.ProfileScreen.buttonCornerRadius
		cancelButton.layer.cornerRadius = Constants.ProfileScreen.buttonCornerRadius
	}
	
	private func setUpProfileImageView() {
		profileImageView.clipsToBounds = true
		profileImageView.contentMode = .scaleAspectFill
		profileImageView.isUserInteractionEnabled = true
		profileImageView.clipsToBounds = true
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didProfileImageViewTapped))
		profileImageView.addGestureRecognizer(gesture)
	}
	
	private func updateProfileImageView(with data: Data?) {
		guard let data = data, let image = UIImage(data: data) else {
			let capitalLetters = nameTextField.text?.getCapitalLetters()
			profileImageView.image = UIImage.textImage(text: capitalLetters)
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
	
	private func addTargets() {
		saveButton.addTarget(self, action: #selector(didSaveButtonTapped), for: .touchUpInside)
		editProfileButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
		closeProfileButton.addTarget(self, action: #selector(didCloseButtonTapped), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(didCancelButtonTapped), for: .touchUpInside)
		locationTextField.addTarget(self, action: #selector(didTextFieldDidChange), for: .editingChanged)
		infoTextField.addTarget(self, action: #selector(didTextFieldDidChange), for: .editingChanged)
		nameTextField.addTarget(self, action: #selector(didTextFieldDidChange), for: .editingChanged)
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
		presenter?.cancel()
		isProfileEditing = false
	}
	
	@objc private func didSaveButtonTapped(_ button: UIButton) {
		locationTextField.resignFirstResponder()
		infoTextField.resignFirstResponder()
		nameTextField.resignFirstResponder()
		changeButtonState(with: false)
		presenter?.save()
	}
	
	@objc private func didEditButtonTapped() {
		cancelButton.isEnabled = true
		isProfileEditing = true
		self.nameTextField.becomeFirstResponder()
	}
	
	@objc private func didCloseButtonTapped() {
		presenter?.close()
	}
	
	@objc private func didTextFieldDidChange() {
		saveButton.isEnabled = true
	}
	
	private func changeButtonState(with isEnable: Bool) {
		cancelButton.isEnabled = isEnable
		saveButton.isEnabled = isEnable
	}
	
	private func updateScreenLayoutDependingOn(isEditing: Bool) {
		saveButton.isHidden = !isEditing
		editProfileButton.isHidden = isEditing
		cancelButton.isHidden = !isEditing
		nameTextField.isEnabled = isEditing
		locationTextField.isEnabled = isEditing
		infoTextField.isEnabled = isEditing
	}
	
	private func useCameraForPhoto() {
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			presentAlert(title: "Warning!", message: "Camera not found", actions: [action])
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
		startObserving { [weak self] keyboardHeight, isKeyboardShowing in
			self?.saveButtonBottomConstraint?.constant = isKeyboardShowing ? keyboardHeight : 0
			self?.nameTextFieldTopConstraint.isActive = !isKeyboardShowing
			UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				self?.profileImageView.isHidden = isKeyboardShowing
				self?.view.layoutIfNeeded()
			}
		}
	}
}
	// MARK: - ProfileViewProtocol

extension UserProfileViewController: ProfileViewProtocol {
	func presentSuccessLoadAlert() {
		let action = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
			self?.isProfileEditing = false
		})
		presentAlert(title: "Data saved", message: nil, actions: [action])
	}
	
	func presentFailureLoadAlert(handler: (() -> Void)?) {
		let actions = [
			UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
				self?.isProfileEditing = false
			}),
			UIAlertAction(title: "Try again", style: .default, handler: { _ in
				if let handler = handler {
					handler()
				}
			})
		]
		presentAlert(title: "Error!", message: "Failed to save data.", actions: actions)
	}
	
	func updateScreen(name: String, location: String, info: String, imageData: Data?) {
		nameTextField.text = name
		locationTextField.text = location
		infoTextField.text = info
		guard let imageData = imageData, let image = UIImage(data: imageData) else {
			profileImageView.image = UIImage.textImage(text: "FN")
			return
		}
		profileImageView.image = image
	}
	
	func activityStartedAnimation() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}
	
	func activityFinishedAnimation() {
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
	}
	
}

	// MARK: - UIImagePickerController

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		imagePicker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			return
		}
		profileImageView.image = image
		editProfileButton.isHidden = true
		saveButton.isHidden = false
		cancelButton.isHidden = false
		changeButtonState(with: true)
		guard let imageData = image.jpegData(compressionQuality: 1.0) else {
			return
		}
		presenter?.updated[Constants.LocalStorage.imageKey] = imageData
	}
}

	// MARK: - UITextFieldDelegate

extension UserProfileViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		guard textField.placeholder != textField.text else {
			return
		}
		let data = (textField.text ?? "").data(using: .utf8)
		if textField == nameTextField {
			presenter?.updated[Constants.LocalStorage.nameKey] = data
		} else if textField == locationTextField {
			presenter?.updated[Constants.LocalStorage.locationKey] = data
		} else if textField == infoTextField {
			presenter?.updated[Constants.LocalStorage.infoKey] = data
		}
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
