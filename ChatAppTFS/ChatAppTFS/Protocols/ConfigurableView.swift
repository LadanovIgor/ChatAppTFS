//
//  ConfigurableView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 07.10.2021.
//

import Foundation

protocol ConfigurableView {
	 associatedtype ConfigurationModel
	 func configure(with model: ConfigurationModel)
 }
