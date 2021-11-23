//
//  RequestFactory.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

struct RequestsFactory {
	struct PixabayRequestConfig {
		static func yellowFlowers() -> RequestConfig<PixabyParser> {
			let request = PixabayRequest(apiKey: "24419822-84c709773b61819bb83958ec7")
			return RequestConfig<PixabyParser>(request: request, parser: PixabyParser())
		}
	}
	
	struct DataRequest {
		static func imageRequest(url: String) -> Request {
			return Request(urlString: url)
		}
	}
}
