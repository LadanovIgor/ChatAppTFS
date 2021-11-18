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
	private var orientationLock = UIInterfaceOrientationMask.portrait
	private var storageService = StorageService()
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		storageService.loadThemeFor(application: application)
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		storageService.createFileLocallyIfNeeded()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		let navVC = UINavigationController()
		let coreDataManager = CoreDataManager()
		let firestoreManager = FireStoreManager()
		firestoreManager.configure()
		let databaseService = ChatService(coreDataManager: coreDataManager, firestoreManager: firestoreManager)
		let assemblyBuilder = AssemblyModuleBuilder(chatService: databaseService)
		let router = Router(navigationController: navVC, assemblyBuilder: assemblyBuilder)
		router.initialScreen(storageService: storageService)
		window?.rootViewController = navVC
		return true
	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return orientationLock
	}
}
