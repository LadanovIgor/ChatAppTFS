//
//  Picture.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

struct Response: Codable {
	let hits: [Picture]
}

struct Picture: Codable {
	let previewURL: String
	let webformatURL: String
}
