//
//  RequestFactory.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

struct RequestsFactory {
	struct PixabayRequestConfig {
		
		static func pictures(with type: Constants.PicturesScreen.PicturesType) -> RequestConfig<PixabyParser> {
			let request: PixabayRequest
			switch type {
			case .sports: request = PixabayRequest(endPoint: .sports)
			case .nature: request = PixabayRequest(endPoint: .nature)
			case .flowers: request = PixabayRequest(endPoint: .flowers)
			case .people: request = PixabayRequest(endPoint: .people)
			case .animals: request = PixabayRequest(endPoint: .animals)
			}
			return RequestConfig<PixabyParser>(request: request, parser: PixabyParser())
		}
	}
	
	struct DataRequest {
		static func imageRequest(url: String) -> Request {
			return Request(urlString: url)
		}
	}
}
