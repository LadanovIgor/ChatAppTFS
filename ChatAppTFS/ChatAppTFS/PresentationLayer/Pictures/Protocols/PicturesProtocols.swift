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
}

protocol PicturesPresenterProtocol: AnyObject, LifeCycleProtocol {
	func didTapAt(indexPath: IndexPath)
	var pictures: [Picture] { get }
	func getImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
