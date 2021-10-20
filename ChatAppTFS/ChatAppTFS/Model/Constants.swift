//
//  UserDefaultsConstants.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 14.10.2021.
//

import Foundation

enum Constants {
	
	enum ThemeScreen {
		static let buttonCornerRadius: CGFloat = 14.0
	}
	
	enum ConversationScreen {
		static let messageViewHeight: CGFloat = 80
	}
	
	enum ProfileScreen {
		static let buttonCornerRadius: CGFloat = 14.0
		static let nameInfoOffset: CGFloat = 16.0
		static let nameCharacters = 20
		static let infoCharacters = 30
	}
	
	enum ConversationListScreen {
		static let barButtonSize: CGFloat = 32.0
	}
	
	enum MessageView {
		static let offset: CGFloat = 18.0
		static let textFieldCornerRadius: CGFloat = 11.0
		static let textFieldBorderWidth: CGFloat = 0.3
	}
	
	enum ConversationCell {
		static let labelWidthMultiplier: CGFloat = 0.7
		static let offset: CGFloat = 10.0
	}
	
	enum PlistManager {
		static let plistFileName = "Data"
		static let nameKey = "name"
		static let infoKey = "info"
		static let locationKey = "location"
		static let imageKey = "image"
		static let themeKey = "theme"
	}
}
