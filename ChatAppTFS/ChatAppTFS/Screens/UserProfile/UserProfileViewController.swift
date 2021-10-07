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
	@IBOutlet weak var saveProfileButton: UIButton!
	@IBOutlet weak var profileDescriptionLabel: UILabel!
	@IBOutlet weak var profileNameLabel: UILabel!
	@IBOutlet weak var topDescriptionLabelConstraint: NSLayoutConstraint!
	@IBOutlet weak var topProfileLabelConstraint: NSLayoutConstraint!
	
	private let imagePicker = UIImagePickerController()
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	// MARK: - Init
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		// View еще не загружено и фреймов у кнопки тем более нет
		// print("Frame Save Button: \(saveProfileButton.frame)")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("Frame Save Button(view did load): \(saveProfileButton.frame)")
		setUpSaveButton()
		addButtonTargets()
		setUpProfileImageView()
		delegating()
		setUpConstraints()
		setUpLabels()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Метод viewDidAppear вызывается после того, как autolayout закончил свою работу. До этого фреймы вьюх на экране часто неверны.
		print("Frame Save Button(view did appear): \(saveProfileButton.frame)")
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		profileImageView.round()
		profileImageView.layer.masksToBounds = true
	}
	
	// MARK: - Private
	
	private func setUpLabels() {
		profileDescriptionLabel.text = "Cartoonist, producer, animator\nPortland, Oregon, U.S."
	}
	
	private func setUpConstraints() {
		if #available(iOS 13, *) {
			topDescriptionLabelConstraint.constant = 32
			topProfileLabelConstraint.constant = 32
		} else {
			topDescriptionLabelConstraint.constant = 12
			topProfileLabelConstraint.constant = 12
		}
	}
	
	private func delegating() {
		imagePicker.delegate = self
	}
	
	private func setUpSaveButton() {
		saveProfileButton.layer.cornerRadius = 14.0
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
		saveProfileButton.addTarget(self, action: #selector(didSaveButtonTapped), for: .touchUpInside)
		editProfileButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
		closeProfileButton.addTarget(self, action: #selector(didCloseButtonTapped), for: .touchUpInside)
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
	
	@objc private func didSaveButtonTapped() {
		// Save profile
	}
	
	@objc private func didEditButtonTapped() {
		// present EditProfile VC
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
