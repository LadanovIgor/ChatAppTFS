//
//  PicturesProtocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

protocol PicturesViewProtocol where Self: UIViewController {
	
}

protocol PicturesPresenterProtocol: AnyObject {
	var pictureSelected: ResultClosure<Data>? { get set }
	func dismiss()
}
