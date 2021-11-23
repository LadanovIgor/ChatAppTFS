//
//  Picture.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

struct Response: Codable {
	let pictures: [Picture]
	
	private enum CodingKeys: String, CodingKey {
		case pictures = "hits"
	}
}

struct Picture: Codable {
	let previewURL: String
	let webformatURL: String
}
