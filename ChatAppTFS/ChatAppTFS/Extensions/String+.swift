//
//  String+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 02.11.2021.
//

import Foundation

extension String {
	func getCapitalLetters() -> String? {
		let splitArray = self.uppercased().split(separator: " ")
		switch splitArray.count {
		case 0: return nil
		case 1:
			guard let character = splitArray.first?.first else { return nil }
			return String(character)
		default:
			guard let character1 = splitArray.first?.first, let character2 = splitArray[1].first else { return nil }
			return String(character1) + String(character2)
		}
	}
}
