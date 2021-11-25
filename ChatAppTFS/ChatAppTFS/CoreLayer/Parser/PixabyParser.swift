//
//  PixabyParser.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

protocol ParserProtocol {
	associatedtype Model
	func parse(data: Data) -> Model?
}

class PixabyParser: ParserProtocol {
	typealias Model = Response
	func parse(data: Data) -> Response? {
		do {
			let response = try JSONDecoder().decode(Model.self, from: data)
			return response
		} catch let error {
			print(error.localizedDescription)
			return nil
		}
	
	}
}
