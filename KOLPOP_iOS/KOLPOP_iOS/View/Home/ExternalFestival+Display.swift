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

    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    var startDate: Date? {
        Self.apiDateFormatter.date(from: fstvlStartDate)
    }

    var endDate: Date? {
        Self.apiDateFormatter.date(from: fstvlEndDate)
    }

    var dateRangeText: String {
        guard let startDate, let endDate else { return "\(fstvlStartDate) - \(fstvlEndDate)" }
        return "\(Self.displayDateFormatter.string(from: startDate)) - \(Self.displayDateFormatter.string(from: endDate))"
    }

    var dDayText: String {
        guard let startDate, let endDate else { return "" }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)

        if today < start {
            let days = calendar.dateComponents([.day], from: today, to: start).day ?? 0
            return "D-\(days)"
        } else if today <= end {
            return "진행중"
        } else {
            return "종료"
        }
    }
}
