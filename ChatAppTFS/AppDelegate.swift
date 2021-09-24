//
//  AppDelegate.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		#if LOGS
		print("Application will be moved from Not running to Inactive:  \(#function)")
		#endif
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		#if LOGS
		print("Application moved from Not running to Inactive:  \(#function)")
<<<<<<< HEAD
=======
		ApplicationStatusWatcher.shared.startMonitor()
		#endif
>>>>>>> parent of f291291 (revert macros)
		return true
	}
	
<<<<<<< HEAD
=======
	func applicationDidBecomeActive(_ application: UIApplication) {
		print("Application moved from Inactive to Active:  \(#function)")

	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		print("Application will be moved from Active to Inactive:  \(#function)")

	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		print("Application moved from Active to Background:  \(#function)")

	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		print("Application will be moved from Background to Foreground:  \(#function)")
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		print("Application will be moved from Background to Suspended:  \(#function)")
	}
>>>>>>> parent of f136c03 (add uiapplication watcher)


	@available(iOS 13.0, *)
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	@available(iOS 13.0, *)
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		
	}


}

