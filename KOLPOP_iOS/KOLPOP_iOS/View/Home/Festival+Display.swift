//
//  Festival+Display.swift
//  KOLPOP_iOS
//

import Foundation

extension Festival {

    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    var startDate: Date? {
        Self.apiDateFormatter.date(from: startDateString)
    }

    var endDate: Date? {
        Self.apiDateFormatter.date(from: endDateString)
    }

    var dateRangeText: String {
        guard let startDate, let endDate else { return "\(startDateString) - \(endDateString)" }
        return "\(Self.displayDateFormatter.string(from: startDate)) - \(Self.displayDateFormatter.string(from: endDate))"
    }

    var dDayText: String {
        if status.uppercased().contains("END") { return "종료" }
        if dDay > 0 { return "D-\(dDay)" }
        return "진행중"
    }
}
