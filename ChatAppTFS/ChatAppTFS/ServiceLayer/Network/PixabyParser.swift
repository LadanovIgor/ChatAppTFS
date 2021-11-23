//
//  PixabyParser.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import Foundation

class PixabyParser: ParserProtocol {
	typealias Model = Response
	func parse(data: Data) -> Response? {
		do {
			let dialogs = try JSONDecoder().decode(Model.self, from: data)
			return dialogs
		} catch let error {
			print(error.localizedDescription)
			return nil
		}
	
	}
}
