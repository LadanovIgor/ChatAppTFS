//
//  RequestSender.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

protocol RequestSenderProtocol {
	func send<Parser>(config: RequestConfig<Parser>, completion: @escaping ResultClosure<Parser.Model>)
	func send(request: RequestProtocol?, completion: @escaping ResultClosure<Data>)
}

class RequestSender: RequestSenderProtocol {
	
	private let cacheURL = URLCache.shared
	private let session = URLSession.shared
	
	// MARK: - Private
	
	private func getDataFrom(urlRequest: URLRequest, completion: @escaping ResultClosure<Data>) {
		if let cachedResponse = cacheURL.cachedResponse(for: urlRequest) {
			completion(.success(cachedResponse.data))
			return
		}
		let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
				completion(.failure(NetworkError.badResponse(response)))
				return
			}
			guard let data = data else {
				completion(.failure(NetworkError.badData))
				return
			}
			let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
			self?.cacheURL.storeCachedResponse(cachedResponse, for: urlRequest)
			completion(.success(data))
		}
		task.resume()
	}
	
	// MARK: - Public
	
	public func send<Parser>(config: RequestConfig<Parser>, completion: @escaping ResultClosure<Parser.Model>) where Parser: ParserProtocol {
		guard let urlRequest = config.request.urlRequest else {
			completion(.failure(NetworkError.badURL))
			return
		}
		getDataFrom(urlRequest: urlRequest) { result in
			switch result {
			case .success(let data):
				guard let parserModel = config.parser.parse(data: data) else {
					completion(.failure(ParsingError.failureParse))
					return
				}
				completion(.success(parserModel))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	public func send(request: RequestProtocol?, completion: @escaping ResultClosure<Data>) {
		guard let urlRequest = request?.urlRequest else {
			completion(.failure(NetworkError.badURL))
			return
		}
		getDataFrom(urlRequest: urlRequest, completion: completion)
	}
}
