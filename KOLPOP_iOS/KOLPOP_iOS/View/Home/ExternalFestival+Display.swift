//
//  ExternalFestival+Display.swift
//  KOLPOP_iOS
//

import Foundation

extension ExternalFestival {

    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    var startDate: Date? {
        Self.apiDateFormatter.date(from: fstvlStartDate)
    }

    var endDate: Date? {
        Self.apiDateFormatter.date(from: fstvlEndDate)
    }
}
