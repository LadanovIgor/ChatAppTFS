//
//  PicturesPresenter.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

class PicturesPresenter: PicturesPresenterProtocol {
	
	weak var view: PicturesViewProtocol?
	
	private var router: RouterProtocol
	
	init(router: RouterProtocol) {
		self.router = router
	}
	
	var pictureSelected: ResultClosure<Data>?
	
	func set(view: PicturesViewProtocol) {
		self.view = view
	}
	
	func dismiss() {
		router.dismiss(view)
	}
}
