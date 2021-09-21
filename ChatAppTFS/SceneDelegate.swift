//
//  SceneDelegate.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.09.2021.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		guard let _ = (scene as? UIWindowScene) else { return }
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		print("Scene moved from Inactive to Diccc:  \(#function)")
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		print("Scene moved from Inactive to Active:  \(#function)")
	}

	func sceneWillResignActive(_ scene: UIScene) {
		print("Scene will be moved from Active to Inactive:  \(#function)")
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		print("Scene will be moved from Inactive to Foreground:  \(#function)")

	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		print("Scene moved from Active to Background:  \(#function)")

	}
	
	

}

