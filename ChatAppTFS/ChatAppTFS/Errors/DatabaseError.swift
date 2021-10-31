//
//  DatabaseError.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 31.10.2021.
//

import Foundation

enum DatabaseError: Error {
	case failureSaving
	case failureFetching
	case invalidData
}
