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
		loadThemeFor(application: application)
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		createFileLocallyIfNeeded()
		FirebaseApp.configure()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		let navVC = UINavigationController()
		let assemblyBuilder = AssemblyModuleBuilder()
		let router = Router(navigationController: navVC, assemblyBuilder: assemblyBuilder)
		router.initialViewController(localStorage: localStorage)
		window?.rootViewController = navVC
		return true
	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return orientationLock
	}
	
	private func loadThemeFor(application: UIApplication) {
		localStorage.loadTheme { result in
			switch result {
			case .success(let data):
				data.setTheme(for: application)
			case .failure:
				LightTheme().apply(for: application)
			}
		}
	}
	
	private func createFileLocallyIfNeeded() {
		guard let sourcePath = Bundle.main.path(forResource: Constants.LocalStorage.plistFileName, ofType: "plist"),
			  let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
			  FileManager.default.fileExists(atPath: sourcePath) else { return }
		let fileURL = directory.appendingPathComponent("\(Constants.LocalStorage.plistFileName).plist")
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			try? FileManager.default.copyItem(atPath: sourcePath, toPath: fileURL.path)
		}
	}
}
