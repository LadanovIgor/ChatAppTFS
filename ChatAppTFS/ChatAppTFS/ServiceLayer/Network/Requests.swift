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
	
	enum SearchTerm: String {
		case sports, flowers, nature, people, animals
	}
	
	lazy var urlRequest: URLRequest? = {
		var queryParams = Constants.PixabayAPI.queryParams
		queryParams["q"] = searchTerm.rawValue
		guard let url = getURL(with: queryParams) else {
			return nil
		}
		let request = URLRequest(url: url)
		return request
	}()
	
	private let searchTerm: SearchTerm
	
	init(searchTerm: SearchTerm) {
		self.searchTerm = searchTerm
	}
	
	private func getURL(with queryParams: [String: String]) -> URL? {
		var urlString = Constants.PixabayAPI.baseUrl
		var queryItems = [URLQueryItem]()
		for (name, value) in queryParams {
			queryItems.append(.init(name: name, value: value))
		}
		urlString += queryItems.map {"\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
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
