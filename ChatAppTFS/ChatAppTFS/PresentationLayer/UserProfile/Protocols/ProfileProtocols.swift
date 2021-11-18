//
//  ProfileProtocols.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 16.11.2021.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject, LifeCycleProtocol {
	func cancel()
	func save()
	func close()
	func update(key: String, value: Data?)
}

protocol ProfileViewProtocol where Self: UIViewController {
	func activityStartedAnimation()
	func activityFinishedAnimation()
	func updateScreen(name: String, location: String, info: String, imageData: Data?)
	func presentFailureLoadAlert(handler: (() -> Void)?)
	func presentSuccessLoadAlert()
}
