//
//  UserProfileController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.11.2021.
//

protocol ProfilePresenterProtocol: AnyObject, LifeCycleProtocol {
	func cancel()
	func save()
	var changedValues: [String: Data] { get set }
}

protocol ProfileViewProtocol: AnyObject {
	func activityStartedAnimation()
	func activityFinishedAnimation()
	func updateScreen(name: String, location: String, info: String, imageData: Data?)
	func presentFailureLoadAlert(handler: (() -> Void)?)
	func presentSuccessLoadAlert()
}

class ProfilePresenter: ProfilePresenterProtocol {
	func save() {
		guard !changedValues.isEmpty else { return }
		saveProfile()
	}
	
	func cancel() {
		getValues(from: loadedValues)
	}
	
	weak var view: ProfileViewProtocol?
	var localStorage: StoredLocally?
	var router: RouterProtocol?
	
	var changedValues = [String: Data]()
	private var loadedValues = [String: Data]()
	
	init(localStorage: StoredLocally?, router: RouterProtocol) {
		self.localStorage = localStorage
		self.router = router
	}
	
	func viewDidLoad() {
		fetchProfileData()
	}
	
	private func fetchProfileData() {
		view?.activityStartedAnimation()
		localStorage?.loadLocally { [weak self] result in
			switch result {
			case .success(let dict):
				self?.loadedValues = dict
				self?.getValues(from: dict)
			case .failure(let error):
				print(error.localizedDescription)
			}
			self?.view?.activityFinishedAnimation()
		}
	}
	
	private func saveProfile() {
		view?.activityStartedAnimation()
		localStorage?.saveLocally(changedValues) { [weak self] result in
			guard let self = self else { return }
			self.view?.activityFinishedAnimation()
			switch result {
			case .success:
				self.view?.presentSuccessLoadAlert()
				self.updateValues(with: self.changedValues)
			case .failure:
				self.view?.presentFailureLoadAlert(handler: self.saveProfile)
			}
		}
	}
	
	private func updateValues(with values: [String: Data]?) {
		guard let values = values else {
			return
		}
		for key in values.keys {
			loadedValues[key] = values[key]
		}
		changedValues = [String: Data]()
	}
	
	func getValues(from dict: [String: Data]) {
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
}
