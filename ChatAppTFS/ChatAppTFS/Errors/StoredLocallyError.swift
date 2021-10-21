//
//  PlistManagerError.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 19.10.2021.
//

import Foundation

enum StoredLocallyError: Error {
	case fileNotWritten
	case fileDoesNotExist
	case fileUnavailable
	case keyValuePairDoesNotExist
	case invalidData
	case couldNotGetData
	case couldNotSaveData
}
