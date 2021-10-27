//
//  typealiases.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

typealias ResultClosure<T> = (Result<T, Error>) -> Void
typealias ThemeClosure = ((ThemeProtocol) -> Void)
