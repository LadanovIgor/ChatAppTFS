//
//  PictureCollectionViewCell.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
	static let identifier = "PictureCollectionViewCell"
	
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "image")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		return imageView
	}()
	
	lazy var imageLoaded: ResultClosure<Data> = { [weak self] result in
		switch result {
		case .success(let data):
			self?.imageView.image = UIImage(data: data)
		case .failure(let error):
			print(error.localizedDescription)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(imageView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		setUpConstraints()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
	
	private func setUpConstraints() {
		imageView.frame = contentView.bounds
		NSLayoutConstraint.activate([
			imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	func configure() {
		imageView.image = UIImage(named: "image")
	}
}
