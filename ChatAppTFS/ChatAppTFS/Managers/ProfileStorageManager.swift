//
//  Profile.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 18.10.2021.
//

import Foundation

enum MultiThreading {
	case gcd
	case operation
}

class ProfileStorageManager {
	static func use(_ type: MultiThreading) -> StoredLocally {
		switch type {
			case .gcd:
				return ProfileStorageManagerGCD.shared
			case .operation:
				return ProfileStorageManagerOperation.shared
		}
	}
}
