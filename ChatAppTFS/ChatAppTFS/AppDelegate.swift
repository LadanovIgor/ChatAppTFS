//
//  AppDelegate.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(
			"Application will be moved from Not running to Inactive:  \(#function)"
		)
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(
			"Application moved from Not running to Inactive:  \(#function)"
		)
		ApplicationAndViewControllerLifecycleObserver.shared.startApplicationLifeCycleObserving()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = ViewController()		
		return true
	}

}

