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

protocol PicturesPresenterProtocol: LifeCycleProtocol {
	func didTapAt(indexPath: IndexPath)
	func didTap(at type: Constants.PicturesScreen.PictureCategory)
	var numberOfSection: Int { get }
	func getData(at indexPath: IndexPath, completion: @escaping (Data) -> Void)
}
