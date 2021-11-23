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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let plistManager = PlistManager()
		let coreDataManager = CoreDataManager()
		let firestoreManager = FireStoreManager()
		let requestSender = RequestSender()
		let storageService = StorageService(plistManager: plistManager)
		let chatService = ChatService(coreDataManager: coreDataManager, firestoreManager: firestoreManager)
		let assemblyBuilder = AssemblyModuleBuilder(chatService: chatService, storageService: storageService, requestSender: requestSender)
		let navVC = UINavigationController()
		let router = Router(navigationController: navVC, assemblyBuilder: assemblyBuilder)
		plistManager.createFileLocallyIfNeeded()
		firestoreManager.configure()
		storageService.loadThemeFor(application: application)
		router.initialScreen()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = navVC
		return true
	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return orientationLock
	}
}
