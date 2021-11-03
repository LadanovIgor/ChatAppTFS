//
//  Profile.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 18.10.2021.
//
import Foundation

extension Character {
	var isAlphabetical: Bool {
		let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
		return alphabet.contains(self.uppercased())
	}
}
