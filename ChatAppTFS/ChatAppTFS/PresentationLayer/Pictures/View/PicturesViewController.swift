//
//  PicturesViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import UIKit

class PicturesViewController: UIViewController, PicturesViewProtocol {
	
	private let collectionView: TouchAnimateCollectionView = {
		let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		let layout = ColumnFlowLayout(cellsPerRow: 3, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: sectionInset)
		let collectionView = TouchAnimateCollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.identifier)
		return collectionView
	}()
	
	private let stackView = UIStackView()
	private let animalsButton = TouchAnimateButton()
	private let natureButton = TouchAnimateButton()
	private let flowersButton = TouchAnimateButton()
	private let sportsButton = TouchAnimateButton()
	private let peopleButton = TouchAnimateButton()

	private let spinner = UIActivityIndicatorView()
	
	private var presenter: PicturesPresenterProtocol
	
	init(presenter: PicturesPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.viewDidLoad()
		setUpButtons()
		setUpStackView()
		setUpActivityIndicator()
		setUpCollectionView()
		delegating()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setUpConstraints()
	}
	
	private func setUpCollectionView() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
	}
	
	private func setUpButtons() {
		let color = Constants.AppColors.buttonTitle.color
		natureButton.setTitle("Nature", for: .normal)
		natureButton.setTitleColor(color, for: .normal)
		natureButton.addTarget(self, action: #selector(didTapNatureButton), for: .touchUpInside)
		animalsButton.setTitle("Animals", for: .normal)
		animalsButton.setTitleColor(color, for: .normal)
		animalsButton.addTarget(self, action: #selector(didTapAnimalsButton), for: .touchUpInside)
		sportsButton.setTitle("Sports", for: .normal)
		sportsButton.setTitleColor(color, for: .normal)
		sportsButton.addTarget(self, action: #selector(didTapSportsButton), for: .touchUpInside)
		peopleButton.setTitle("People", for: .normal)
		peopleButton.setTitleColor(color, for: .normal)
		peopleButton.addTarget(self, action: #selector(didTapPeopleButton), for: .touchUpInside)
		flowersButton.setTitle("Flowers", for: .normal)
		flowersButton.setTitleColor(color, for: .normal)
		flowersButton.addTarget(self, action: #selector(didTapFlowersButton), for: .touchUpInside)
	}
	
	private func setUpStackView() {
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.addArrangedSubview(peopleButton)
		stackView.addArrangedSubview(natureButton)
		stackView.addArrangedSubview(flowersButton)
		stackView.addArrangedSubview(sportsButton)
		stackView.addArrangedSubview(animalsButton)
		stackView.alignment = .fill
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		view.addSubview(stackView)
	}
	
	private func setUpActivityIndicator() {
		spinner.hidesWhenStopped = true
		spinner.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(spinner)
	}
	
	private func delegating() {
		collectionView.delegate = self
		collectionView.dataSource = presenter
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			stackView.heightAnchor.constraint(equalToConstant: 50),
			collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			spinner.heightAnchor.constraint(equalToConstant: 100),
			spinner.widthAnchor.constraint(equalToConstant: 100)
		])
	}
	
	@objc private func didTapNatureButton() {
		presenter.didTap(at: .nature)
	}
	
	@objc private func didTapAnimalsButton() {
		presenter.didTap(at: .animals)
	}
	
	@objc private func didTapSportsButton() {
		presenter.didTap(at: .sports)
	}
	
	@objc private func didTapPeopleButton() {
		presenter.didTap(at: .people)
	}
	
	@objc private func didTapFlowersButton() {
		presenter.didTap(at: .flowers)
	}
	
	func reload() {
		collectionView.reloadData()
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
		presenter.didTapAt(indexPath: indexPath)
	}
}
