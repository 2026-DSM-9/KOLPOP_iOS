//
//  Festival.swift
//  KOLPOP_iOS
//

import Foundation

struct Festival {
    let id: String
    let name: String
    let place: String
    let address: String
    let region: String
    let startDateString: String
    let endDateString: String
    let status: String
    let dDay: Int
    let nearbyListingCount: Int
    let latitude: Double
    let longitude: Double
    /// 목록/캘린더 응답(FestivalSummaryResponse)에는 없고 상세 응답(FestivalDetailResponse)에만 있다.
    let content: String?
}

extension Festival {

    init(summary: FestivalSummaryResponse) {
        id = summary.id
        name = summary.name
        place = summary.place
        address = summary.address
        region = summary.region
        startDateString = summary.startDate
        endDateString = summary.endDate
        status = summary.status
        dDay = Int(summary.dDay)
        nearbyListingCount = summary.nearbyListingCount
        latitude = summary.latitude
        longitude = summary.longitude
        content = nil
    }

    init(detail: FestivalDetailResponse) {
        id = detail.id
        name = detail.name
        place = detail.place
        address = detail.address
        region = detail.region
        startDateString = detail.startDate
        endDateString = detail.endDate
        status = detail.status
        dDay = Int(detail.dDay)
        nearbyListingCount = detail.nearbyListings.count
        latitude = detail.latitude
        longitude = detail.longitude
        content = detail.content
    }
}

struct FestivalSummaryResponse: Decodable {
    let id: String
    let name: String
    let place: String
    let address: String
    let region: String
    let startDate: String
    let endDate: String
    let status: String
    let dDay: Int64
    let nearbyListingCount: Int
    let latitude: Double
    let longitude: Double
}

struct FestivalListResponse: Decodable {
    let totalCount: Int
    let page: Int
    let size: Int
    let festivals: [FestivalSummaryResponse]
}

struct FestivalDetailResponse: Decodable {
    let id: String
    let name: String
    let place: String
    let content: String
    let address: String
    let region: String
    let startDate: String
    let endDate: String
    let status: String
    let dDay: Int64
    let latitude: Double
    let longitude: Double
    let nearbyListings: [ListingSummaryResponse]
}
