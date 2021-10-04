//
//  AppDelegate.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

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

		return true
	}

	@available(iOS 13.0, *)
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}



	@available(iOS 13.0, *)

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		
	}


}

