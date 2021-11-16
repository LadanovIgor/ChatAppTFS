//
//  AppDelegate.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var orientationLock = UIInterfaceOrientationMask.portrait
	var localStorage = LocalStorageService()
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		localStorage.loadThemeFor(application: application)
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		localStorage.createFileLocallyIfNeeded()
		FirebaseApp.configure()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		let navVC = UINavigationController()
		let coreDataManager = CoreDataManager()
		let firestoreManager = FireStoreManager()
		let databaseService = DatabaseService(coreDataManager: coreDataManager, firestoreManager: firestoreManager)
		let assemblyBuilder = AssemblyModuleBuilder(databaseService: databaseService)
		let router = Router(navigationController: navVC, assemblyBuilder: assemblyBuilder)
		router.initialScreen(localStorage: localStorage)
		window?.rootViewController = navVC
		return true
	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return orientationLock
	}
}
