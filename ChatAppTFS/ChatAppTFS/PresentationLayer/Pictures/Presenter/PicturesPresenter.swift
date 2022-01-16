//
//  PicturesPresenter.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

class PicturesPresenter: NSObject {
	
	weak var view: PicturesViewProtocol?
	
	private let router: RouterProtocol
	private let requestSender: RequestSenderProtocol
	
	var pictures = [Picture]()
	
	var pictureSelected: ((Data) -> Void)?
	var pictureSelectedURL: ((String) -> Void)?
	
	init(requestSender: RequestSenderProtocol, router: RouterProtocol) {
		self.router = router
		self.requestSender = requestSender
	}
	
	func viewDidLoad() {
		fetchingData(with: .people)
	}
	
	func set(view: PicturesViewProtocol) {
		self.view = view
	}
	
	func didTap(at type: Constants.PicturesScreen.PictureCategory) {
		fetchingData(with: type)
	}
	
	private func getData(url: String, completion: @escaping (Data) -> Void ) {
		let request = RequestsFactory.dataRequest(url: url)
		requestSender.send(request: request) { result in
			switch result {
			case .success(let data):
				completion(data)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	private func fetchingData(with type: Constants.PicturesScreen.PictureCategory) {
		let requestConfig = RequestsFactory.PixabayRequestConfig.pictures(with: type)
		view?.runSpinner()
		requestSender.send(config: requestConfig) { [weak self] result in
			switch result {
			case .success(let model):
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
					self?.pictures = model.pictures
					self?.view?.reload()
					self?.view?.stopSpinner()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}

	// MARK: - PicturesPresenterProtocol

extension PicturesPresenter: PicturesPresenterProtocol {
	func getData(at indexPath: IndexPath, completion: @escaping (Data) -> Void) {
		let url = pictures[indexPath.row].previewURL
		getData(url: url, completion: completion)
	}
	
	var numberOfSection: Int {
		return pictures.count
	}
    
	func didTapAt(indexPath: IndexPath) {
		if let pictureSelected = pictureSelected {
			getData(url: pictures[indexPath.row].webformatURL, completion: pictureSelected)
		}
		pictureSelectedURL?(pictures[indexPath.row].previewURL)
		router.dismiss(view)
	}
}
