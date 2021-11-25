//
//  RequestFactory.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
	let request: RequestProtocol
	let parser: Parser
}

struct RequestsFactory {
	struct PixabayRequestConfig {		
		static func pictures(with type: Constants.PicturesScreen.PictureCategory) -> RequestConfig<PixabyParser> {
			let request: PixabayRequest
			switch type {
			case .sports: request = PixabayRequest(searchTerm: .sports)
			case .nature: request = PixabayRequest(searchTerm: .nature)
			case .flowers: request = PixabayRequest(searchTerm: .flowers)
			case .people: request = PixabayRequest(searchTerm: .people)
			case .animals: request = PixabayRequest(searchTerm: .animals)
			}
			return RequestConfig<PixabyParser>(request: request, parser: PixabyParser())
		}
	}
	
	static func dataRequest(url: String) -> Request {
		return Request(urlString: url)
	}
}
