//
//  NSSet+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 31.10.2021.
//

import Foundation

extension NSSet {
  func toArray<T>() -> [T] {
	let array = self.compactMap({ $0 as? T})
	return array
  }
}
