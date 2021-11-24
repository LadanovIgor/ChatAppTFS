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
			guard let character = splitArray.first?.first, character.isAlphabetical else { return nil }
			return String(character)
		default:
			guard let character1 = splitArray.first?.first, character1.isAlphabetical else { return nil }
			guard let character2 = splitArray[1].first, character2.isAlphabetical else { return String(character1)}
			return String(character1) + String(character2)
		}
	}
}

extension String {
	var isValidURL: Bool {
		guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
			  let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) else {
			return false
		}
		return match.range.length == self.utf16.count
	}
}
