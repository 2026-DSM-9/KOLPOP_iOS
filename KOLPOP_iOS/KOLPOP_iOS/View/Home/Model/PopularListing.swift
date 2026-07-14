//
//  PopularListing.swift
//  KOLPOP_iOS
//

import Foundation

struct PopularListing {
    let id: Int
    let imageURL: URL?
    let title: String
    let address: String
    let sizeInfo: String
    let price: String
    let likeCount: Int
}

struct PopupCategory {
    let title: String
}

extension PopularListing {

    init(summary: ListingSummaryResponse) {
        id = summary.listingId
        imageURL = summary.thumbnailUrl.flatMap(URL.init(string:))
        title = summary.title
        address = summary.address
        sizeInfo = String(format: "%.1fm²", summary.area)
        price = "일 \(summary.dailyFee.formattedWithComma)원"
        likeCount = summary.likeCount
    }
}

private extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
