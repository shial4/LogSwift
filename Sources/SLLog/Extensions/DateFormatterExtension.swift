//
//  DateFormatterExtension.swift
//  SLLog
//
//  Created by Shial on 4/10/17.
//

import Foundation

extension DateFormatter {
    public convenience init(dateFormat: String, timeZone: String, locale: String) {
        self.init()
        self.dateFormat = dateFormat
        self.timeZone = TimeZone(abbreviation: timeZone)
        self.locale = Locale(identifier: locale)
    }
}
