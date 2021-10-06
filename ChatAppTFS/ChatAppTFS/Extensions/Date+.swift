//
//  Date+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 06.10.2021.
//

import Foundation

extension Date {

	static func randomBetween(start: Date, end: Date) -> Date {
		var date1 = start
		var date2 = end
		if date2 < date1 {
			(date1, date2) = (date2, date1)
		}
		let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
		return Date(timeIntervalSinceNow: span)
	}
	
	var shortDateFormateTodayOrEarlier: String {
		let diffFromNow = self.timeIntervalSinceNow
		let dateFormatter = DateFormatter()
		if diffFromNow > -86400 {
			dateFormatter.dateFormat = "HH:mm"
		} else {
			dateFormatter.dateFormat = "dd MMM"
		}
		return dateFormatter.string(from: self)
	}
}
