//
//  typealiases.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 13.10.2021.
//

import Foundation

typealias ThemeClosure<T> = ((T) -> Void)  where T: ThemeProtocol
