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
	
	var pictureSelected: ResultClosure<Data>?
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
	
	private func getData(url: String, completion: @escaping ResultClosure<Data>) {
		let request = RequestsFactory.dataRequest(url: url)
		requestSender.send(request: request, completion: completion)
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
	func didTapAt(indexPath: IndexPath) {
		if let pictureSelected = pictureSelected {
			getData(url: pictures[indexPath.row].webformatURL, completion: pictureSelected)
		}
		pictureSelectedURL?(pictures[indexPath.row].previewURL)
		router.dismiss(view)
	}
}

	// MARK: - UICollectionViewDataSource

extension PicturesPresenter {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pictures.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell else {
			fatalError()
		}
		cell.configure()
		let url = pictures[indexPath.row].previewURL
		cell.tag = indexPath.row
		getData(url: url) { result in
			DispatchQueue.main.async {
				if cell.tag == indexPath.row {
					cell.imageLoaded(result)
				}
			}
		}
		return cell
	}
}
