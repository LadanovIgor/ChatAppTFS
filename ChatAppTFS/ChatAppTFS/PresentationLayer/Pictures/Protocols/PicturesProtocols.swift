//
//  PicturesProtocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

protocol PicturesViewProtocol: Dismissable {
	func runSpinner()
	func stopSpinner()
	func reload()
}

protocol PicturesPresenterProtocol: LifeCycleProtocol, UICollectionViewDataSource {
	func didTapAt(indexPath: IndexPath)
	func didTap(at type: Constants.PicturesScreen.PictureCategory)
}
