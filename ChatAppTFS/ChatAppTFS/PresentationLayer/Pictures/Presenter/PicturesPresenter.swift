//
//  PicturesPresenter.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

class PicturesPresenter: PicturesPresenterProtocol {
	
	weak var view: PicturesViewProtocol?
	
	private let router: RouterProtocol
	private let requestSender: RequestSenderProtocol
	
	var pictures = [Picture]()
	
	var pictureSelected: ResultClosure<Data>?
	var pictureSelectedURL: ((String) -> Void)?
	
	init(requestSender: RequestSenderProtocol, router: RouterProtocol) {
		self.router = router
		self.requestSender = requestSender
	}
	
	func viewDidLoad() {
		fetchingData()
	}
	
	func set(view: PicturesViewProtocol) {
		self.view = view
	}

	func didTapAt(indexPath: IndexPath) {
		if let pictureSelected = pictureSelected {
			getImageData(urlString: pictures[indexPath.row].webformatURL, completion: pictureSelected)
		}
		pictureSelectedURL?(pictures[indexPath.row].previewURL)
		router.dismiss(view)
	}
	
	func getImageData(urlString: String, completion: @escaping ResultClosure<Data>) {
		let request = RequestsFactory.DataRequest.imageRequest(url: urlString)
		requestSender.send(request: request, completion: completion)
	}
	
	func fetchingData() {
		view?.runSpinner()
		let requestConfig = RequestsFactory.PixabayRequestConfig.yellowFlowers()
		requestSender.send(config: requestConfig) { [weak self] result in
		switch result {
		case .success(let model):
			DispatchQueue.main.async {
				self?.pictures = model.pictures
				DispatchQueue.main.async {
					self?.view?.stopSpinner()
				}
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
		}
	}
}
