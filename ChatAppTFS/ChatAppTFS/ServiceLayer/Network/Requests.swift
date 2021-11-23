//
//  Requests.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

class PixabayRequest: RequestProtocol {
	lazy var urlRequest: URLRequest? = {
		let urlString = "https://pixabay.com/api/?key=" + apiKey + "&q=yellow+flowers&image_type=photo&pretty=true&per_page=100"
		guard let url = URL(string: urlString) else {
			return nil
		}
		let request = URLRequest(url: url)
		return request
	}()
	
	private let apiKey: String
	
	init(apiKey: String) {
		self.apiKey = apiKey
	}
}

class Request: RequestProtocol {
	lazy var urlRequest: URLRequest? = {
		guard let url = URL(string: urlString) else {
			return nil
		}
		let request = URLRequest(url: url)
		return request
	}()
	
	private var urlString: String
	
	init(urlString: String) {
		self.urlString = urlString
	}
}
