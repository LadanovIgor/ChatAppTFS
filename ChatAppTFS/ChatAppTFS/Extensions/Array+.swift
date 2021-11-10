//
//  Array+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 10.11.2021.
//

import Foundation

extension Array where Element == Channel {
	func contains(channelId: String) -> Bool {
		for index in self.indices where self[index].id == channelId {
				return true
		}
		return false
	}
}
