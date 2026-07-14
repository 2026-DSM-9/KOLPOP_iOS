//
//  ListingSummary.swift
//  KOLPOP_iOS
//

import Foundation

/// 지도 검색 결과, 찜한 매물 목록 등 여러 화면에서 공통으로 쓰는 매물 카드 표시 정보.
struct ListingSummary {
    let id: String
    let imageURL: URL?
    let title: String
    let address: String
    let sizeInfo: String
    let category: String
    let price: String
    let likeCount: Int
}

extension ListingSummary {

    /// ListingSummaryResponse에는 실제 category(업종) 정보가 없어 status.label로 대체한다.
    init(response: ListingSummaryResponse) {
        id = String(response.listingId)
        imageURL = response.thumbnailUrl.flatMap(URL.init(string:))
        title = response.title
        address = response.address
        sizeInfo = String(format: "%.1fm²", response.area)
        category = response.status.label
        price = "일 \(response.dailyFee.formattedWithComma)원"
        likeCount = response.likeCount
    }
}
