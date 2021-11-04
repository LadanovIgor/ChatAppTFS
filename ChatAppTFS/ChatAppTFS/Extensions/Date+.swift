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
	
	var todayOrEarlier: String {
		let dateFormatter = DateFormatter()
		let isToday = Calendar.current.isDateInToday(self)
		dateFormatter.dateFormat = isToday ? "HH:mm" : "dd MMM"
		return dateFormatter.string(from: self)
	}
}
