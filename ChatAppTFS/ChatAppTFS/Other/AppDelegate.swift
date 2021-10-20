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
	var orientationLock = UIInterfaceOrientationMask.portrait
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		loadThemeFor(application: application)
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		PlistManager.shared.start()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		let navVC = UINavigationController(rootViewController: ConversationsListViewController())
		window?.rootViewController = navVC
		return true
	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return orientationLock
	}
	
	private func loadThemeFor(application: UIApplication) {
		ProfileStorageManagerGCD.shared.loadTheme { result in
			switch result {
				case .success(let data):
					data.setTheme(for: application)
				case .failure(_):
					LightTheme().apply(for: application)
			}
		}
	}
}


