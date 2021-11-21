//
//  PicturesViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import UIKit

class PicturesViewController: UIViewController, PicturesViewProtocol {
	
	private let collectionView: UICollectionView = {
		let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		let layout = ColumnFlowLayout(cellsPerRow: 3, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: sectionInset)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.identifier)
		return collectionView
	}()
	
	private let spinner = UIActivityIndicatorView()
	
	var pictures = [Picture]()
	
	private var presenter: PicturesPresenterProtocol?
	
	convenience init(presenter: PicturesPresenterProtocol) {
		self.init()
		self.presenter = presenter
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpActivityIndicator()
		setUpCollectionView()
		view.backgroundColor = .brown
		delegating()
		callForImages()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setUpConstraints()
	}
	
	func getImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
		DispatchQueue.global().async {
			let request = URLRequest(url: url)
			let task = URLSession.shared.dataTask(with: request) { data, _, error in
				if let error = error {
					completion(.failure(error))
					return
				}
				guard let data = data else {
					completion(.failure(NetworkError.dataNone))
					return
				}
				completion(.success(data))
			}
			task.resume()
		}
		
	}
	
	func callForImages() {
		let urlString = "https://pixabay.com/api/?key=24419822-84c709773b61819bb83958ec7&q=yellow+flowers&image_type=photo&pretty=true&per_page=100"
		guard let url = URL(string: urlString) else {
			fatalError()
		}
		let request = URLRequest(url: url)

		let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				// TODO: error
				return
			}
			do {
				let result = try JSONDecoder().decode(Response.self, from: data)
				self?.pictures = result.hits
				DispatchQueue.main.async {
					self?.spinner.stopAnimating()
					self?.collectionView.isHidden = false
					self?.collectionView.reloadData()
				}
			} catch {
				print(error.localizedDescription)
			}
		}
		task.resume()
	}
	
	private func setUpCollectionView() {
		collectionView.isHidden = true
		view.addSubview(collectionView)
	}
	
	private func setUpActivityIndicator() {
		spinner.hidesWhenStopped = true
		spinner.startAnimating()
		spinner.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(spinner)
	}
	
	private func delegating() {
		collectionView.delegate = self
		collectionView.dataSource = self
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			spinner.heightAnchor.constraint(equalToConstant: 100),
			spinner.widthAnchor.constraint(equalToConstant: 100)
		])
	}
}

// MARK: - UICollectionViewDelegate

extension PicturesViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let url = URL(string: pictures[indexPath.row].webformatURL) else {
			fatalError("Wrong image URL")
		}
		guard let pictureSelected = presenter?.pictureSelected else {
			fatalError()
		}
		getImageData(from: url, completion: pictureSelected)
		presenter?.dismiss()
	}
	
}

extension PicturesViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pictures.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell else {
			fatalError()
		}
		guard let url = URL(string: pictures[indexPath.row].previewURL) else {
			fatalError("Wrong image URL")
		}
		cell.configure()
		getImageData(from: url, completion: cell.imageLoaded)
		return cell
	}
}

class ColumnFlowLayout: UICollectionViewFlowLayout {

	let cellsPerRow: Int

	init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat, minimumLineSpacing: CGFloat, sectionInset: UIEdgeInsets) {
		self.cellsPerRow = cellsPerRow
		super.init()
		self.minimumInteritemSpacing = minimumInteritemSpacing
		self.minimumLineSpacing = minimumLineSpacing
		self.sectionInset = sectionInset
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		let interItemSpacing = minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
		let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + interItemSpacing
		let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
		itemSize = CGSize(width: itemWidth, height: itemWidth)
	}
}
