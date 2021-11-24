//
//  RequestSender.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
	let request: RequestProtocol
	let parser: Parser
}

protocol RequestSenderProtocol {
	func send<Parser>(config: RequestConfig<Parser>, completion: @escaping ResultClosure<Parser.Model>)
	func send(request: RequestProtocol?, completion: @escaping ResultClosure<Data>)
}

class RequestSender: RequestSenderProtocol {
	let session = URLSession.shared
	private func getDataFrom(urlRequest: URLRequest, completion: @escaping ResultClosure<Data>) {
		let task = session.dataTask(with: urlRequest) { data, _, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else {
				completion(.failure(NetworkError.failureGettingData))
				return
			}
			completion(.success(data))
		}
		task.resume()
	}
	
	func send<Parser>(config: RequestConfig<Parser>, completion: @escaping ResultClosure<Parser.Model>) where Parser: ParserProtocol {
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
	
	func send(request: RequestProtocol?, completion: @escaping ResultClosure<Data>) {
		guard let urlRequest = request?.urlRequest else {
			completion(.failure(NetworkError.badURL))
			return
		}
		getDataFrom(urlRequest: urlRequest, completion: completion)
	}
}
