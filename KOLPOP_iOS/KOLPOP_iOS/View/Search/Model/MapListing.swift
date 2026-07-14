//
//  MapListing.swift
//  KOLPOP_iOS
//

import Foundation
import MapKit

struct MapListing {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
    let address: String
    let sizeInfo: String
    let category: String
    let landlordName: String
    let price: String
    let priceBadge: String
    let statusText: String
    let imageURL: URL?
    let likeCount: Int

    var summary: ListingSummary {
        ListingSummary(
            id: id,
            imageURL: imageURL,
            title: title,
            address: address,
            sizeInfo: sizeInfo,
            category: category,
            price: price,
            likeCount: likeCount
        )
    }
}

extension MapListing {

    /// ListingMapItemResponse에는 썸네일/평수/찜 개수/임대인 이름 정보가 없어 기본값으로 채운다.
    init(response: ListingMapItemResponse) {
        id = String(response.listingId)
        coordinate = CLLocationCoordinate2D(latitude: response.latitude, longitude: response.longitude)
        title = response.title
        address = response.address
        sizeInfo = "보증금 \(response.deposit.formattedWithComma)원"
        category = response.status.label
        landlordName = ""
        price = "일 \(response.dailyFee.formattedWithComma)원"
        priceBadge = "\(response.dailyFee.formattedWithComma)원"
        statusText = response.status.label
        imageURL = nil
        likeCount = 0
    }
}

final class ListingAnnotation: NSObject, MKAnnotation {
    let listing: MapListing
    var coordinate: CLLocationCoordinate2D { listing.coordinate }

    init(listing: MapListing) {
        self.listing = listing
    }
}
