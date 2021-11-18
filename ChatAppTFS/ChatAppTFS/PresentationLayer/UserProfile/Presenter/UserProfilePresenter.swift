//
//  UserProfileController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

class ProfilePresenter {
	
	// MARK: - Properties

	private weak var view: ProfileViewProtocol?
	private var storageService: StoredLocally?
	private var router: RouterProtocol?
	private var stored = [String: Data]()
	var updated = [String: Data]()
	
	// MARK: - Init
	
	init(storageService: StoredLocally?, router: RouterProtocol) {
		self.storageService = storageService
		self.router = router
	}
	
	// MARK: - Private
	
	private func fetchProfileData() {
		view?.activityStartedAnimation()
		storageService?.load { [weak self] result in
			switch result {
			case .success(let dict):
				self?.stored = dict
				self?.getValues(from: dict)
			case .failure(let error):
				print(error.localizedDescription)
			}
			self?.view?.activityFinishedAnimation()
		}
	}
	
	private func saveProfile() {
		view?.activityStartedAnimation()
		storageService?.save(updated) { [weak self] result in
			guard let self = self else { return }
			self.view?.activityFinishedAnimation()
			switch result {
			case .success:
				self.view?.presentSuccessLoadAlert()
				self.updateProfile(with: self.updated)
			case .failure:
				self.view?.presentFailureLoadAlert(handler: self.saveProfile)
			}
		}
	}
	
	private func updateProfile(with dict: [String: Data]?) {
		guard let dict = dict else { return }
		dict.keys.forEach { stored[$0] = dict[$0] }
		updated = [String: Data]()
	}
	
	private func getValues(from dict: [String: Data]) {
		DispatchQueue.global(qos: .userInteractive).async {
			let nameText: String
			let infoText: String
			let locationText: String
			if let nameData = dict[Constants.LocalStorage.nameKey], let name = String(data: nameData, encoding: .utf8) {
				nameText = name
			} else {
				nameText = "Full name"
			}
			if let infoData = dict[Constants.LocalStorage.infoKey], let info = String(data: infoData, encoding: .utf8) {
				infoText = info
			} else {
				infoText = "About youself"
			}
			if let locationData = dict[Constants.LocalStorage.locationKey], let location = String(data: locationData, encoding: .utf8) {
				locationText = location
			} else {
				locationText = "Location"
			}
			let imageData = dict[Constants.LocalStorage.imageKey]
			DispatchQueue.main.async { [weak self] in
				self?.view?.updateScreen(name: nameText, location: locationText, info: infoText, imageData: imageData)
			}
		}
	}
	
	// MARK: - Public

	public func set(view: ProfileViewProtocol?) {
		self.view = view
	}
}

	// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
	
	public func viewDidLoad() {
		fetchProfileData()
	}
	
	public func update(key: String, value: Data?) {
		guard let value = value else { return }
		updated.updateValue(value, forKey: key)
	}
	
	public func close() {
		router?.dismiss(view)
	}
	
	public func save() {
		guard !updated.isEmpty else { return }
		saveProfile()
	}
	
	public func cancel() {
		getValues(from: stored)
	}
}
	
