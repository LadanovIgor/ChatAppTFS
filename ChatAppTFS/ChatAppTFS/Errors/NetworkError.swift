//
//  NetworkError.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

enum NetworkError: Error {
	case dataNone
	case badURL
	case badData
	case badResponse(URLResponse?)
	case wrongDataFromURL
}
