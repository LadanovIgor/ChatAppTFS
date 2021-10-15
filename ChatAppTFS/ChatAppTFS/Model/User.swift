//
//  User.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation

struct User {
	let name: String
	let isOnline: Bool
	let messages: [Message]?
}
