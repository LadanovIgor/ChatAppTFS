//
//  Requests.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

protocol RequestProtocol {
	var urlRequest: URLRequest? { get }
}

class PixabayRequest: RequestProtocol {
	lazy var urlRequest: URLRequest? = {
		guard let url = url(
			queryParams: ["q": endPoint.rawValue, "per_page": "100"]
		) else {
			return nil
		}
		let request = URLRequest(url: url)
		return request
	}()
	
	enum Endpoint: String {
		case sports, flowers, nature, people, animals
	}
	
	private let endPoint: Endpoint
	
	init(endPoint: Endpoint) {
		self.endPoint = endPoint
	}
	
	private func url(queryParams: [String: String] = [:] ) -> URL? {
		var queryItems = [URLQueryItem]()
		queryItems.append(.init(name: "key", value: Constants.PixabayAPI.apiKey))
		for (name, value) in queryParams {
			queryItems.append(.init(name: name, value: value))
		}
		let urlString = Constants.PixabayAPI.baseUrl + "?" + queryItems.map {"\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
		return URL(string: urlString)
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
