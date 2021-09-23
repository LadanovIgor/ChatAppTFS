//
//  ApplicationStatusWatcher.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.09.2021.
//

import UIKit

final class ApplicationStatusWatcher {
	static let shared = ApplicationStatusWatcher()
	
	private init() {}
	
	public func startMonitor() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(didBecomeActiveNotification(notification:)),
											   name: UIApplication.didBecomeActiveNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(willResignActiveNotification(notification:)),
											   name: UIApplication.willResignActiveNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(didEnterBackgroundNotification(notification:)),
											   name: UIApplication.didEnterBackgroundNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(willEnterForegroundNotification(notification:)),
											   name: UIApplication.willEnterForegroundNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(willTerminateNotification(notification:)),
											   name: UIApplication.willTerminateNotification,
											   object: nil)
	}
	
	@objc func didBecomeActiveNotification(notification: Notification) {
		print("Application moved from Inactive to Active:  applicationDidBecomeActive(_:)")
	}
	
	@objc func willResignActiveNotification(notification: Notification) {
		print("Application will be moved from Active to Inactive:  applicationWillResignActive(_:)")
	}
	
	@objc func didEnterBackgroundNotification(notification: Notification) {
		print("Application moved from Active to Background:  applicationDidEnterBackground(_:)")
	}
	
	@objc func willEnterForegroundNotification(notification: Notification) {
		print("Application will be moved from Background to Foreground:  applicationWillEnterForeground(_:)")
	}
	
	@objc func willTerminateNotification(notification: Notification) {
		print("Application will be moved from Background to Suspended:  applicationWillTerminate(_:)")
	}
}
