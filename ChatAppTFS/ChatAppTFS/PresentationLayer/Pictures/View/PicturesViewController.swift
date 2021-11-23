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
	
	private var presenter: PicturesPresenterProtocol?
	
	convenience init(presenter: PicturesPresenterProtocol) {
		self.init()
		self.presenter = presenter
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpActivityIndicator()
		setUpCollectionView()
		presenter?.viewDidLoad()
		delegating()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setUpConstraints()
	}
	
	private func setUpCollectionView() {
		view.addSubview(collectionView)
	}
	
	private func setUpActivityIndicator() {
		spinner.hidesWhenStopped = true
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
	
	func runSpinner() {
		collectionView.isHidden = true
		spinner.startAnimating()
	}
	
	func stopSpinner() {
		spinner.stopAnimating()
		collectionView.isHidden = false
		collectionView.reloadData()
	}
}

// MARK: - UICollectionViewDelegate

extension PicturesViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didTapAt(indexPath: indexPath)
	}
	
}

extension PicturesViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter?.pictures.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell else {
			fatalError()
		}
		cell.configure()
		guard let urlString = presenter?.pictures[indexPath.row].previewURL else {
			return cell
		}
		presenter?.getImageData(urlString: urlString, completion: cell.imageLoaded)
		return cell
	}
}
