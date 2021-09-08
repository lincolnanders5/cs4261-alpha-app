//
//  TimeDoctor.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import Foundation

extension Date {
	static let relativeFormatter = RelativeDateTimeFormatter()
	func toRelative() -> String {
		Date.relativeFormatter.localizedString(for: self, relativeTo: Date())
	}
}

extension DateFormatter {
	static let iso8601Full: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		//					   "2020-08-21 T 04:29:48.000Z"
		return formatter
	}()
}
