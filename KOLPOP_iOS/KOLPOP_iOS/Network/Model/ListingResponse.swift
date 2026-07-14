//
//  ListingResponse.swift
//  KOLPOP_iOS
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
}

struct ListingStatusResponse: Decodable {
    let code: String
    let label: String
}

struct ListingSummaryResponse: Decodable {
    let listingId: Int
    let title: String
    let thumbnailUrl: String?
    let address: String
    let dailyFee: Int
    let deposit: Int
    let area: Double
    let likeCount: Int
    let viewCount: Int
    let reservationCount: Int
    let status: ListingStatusResponse
}

struct ListingListResponse: Decodable {
    let count: Int
    let listings: [ListingSummaryResponse]
}

struct ListingDetailResponse: Decodable {
    let listingId: Int
    let title: String
    let address: String
    let detailAddress: String?
    let imageUrls: [String]
    let dailyFee: Int
    let deposit: Int
    let area: Double
    let sevenDayTotalFee: Int
    let landlordId: Int
    let landlordName: String
    let likeCount: Int
    let viewCount: Int
    let reservationCount: Int
    let operatingStartDate: String
    let operatingEndDate: String
    let minOperatingDays: Int
    let maxOperatingDays: Int
    let facilities: [String]
    let industryRestrictions: [String]
    let additionalRestrictions: [String]
    let description: String
    let hashtags: [String]
    let latitude: Double
    let longitude: Double
    let status: ListingStatusResponse
}

struct ListingMapItemResponse: Decodable {
    let listingId: Int
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    let deposit: Int
    let dailyFee: Int
    let status: ListingStatusResponse
}

struct ListingMapResponse: Decodable {
    let count: Int
    let listings: [ListingMapItemResponse]
}

struct ListingDiscoveryResponse: Decodable {
    let map: ListingMapResponse
    let nearbyListings: ListingListResponse
}
