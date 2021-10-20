//
//  ApplicationStatusWatcher.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.09.2021.
//

import UIKit

protocol KeyboardObservable: AnyObject {
	func stopObserving()
	func startObserving(completion: @escaping (CGFloat, Bool)->Void)
}

extension KeyboardObservable {
	
	private func handleKeyboardNotification(notification: Notification, completion: @escaping (CGFloat, Bool)->Void) {
		guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		let keyboardHeight = keyboardFrame.cgRectValue.height
		let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
		completion(keyboardHeight, isKeyboardShowing)
	}
	
	func startObserving(completion: @escaping (CGFloat, Bool)->Void) {
		NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillShowNotification,
			object: nil,
			queue: nil) { notification in
				self.handleKeyboardNotification(notification: notification, completion: completion)
			}
		NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillHideNotification,
			object: nil,
			queue: nil) { notification in
				self.handleKeyboardNotification(notification: notification, completion: completion)
			}
	}
	
	func stopObserving() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
	}
}
