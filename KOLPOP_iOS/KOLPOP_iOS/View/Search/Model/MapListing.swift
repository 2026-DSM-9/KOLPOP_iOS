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

final class ListingAnnotation: NSObject, MKAnnotation {
    let listing: MapListing
    var coordinate: CLLocationCoordinate2D { listing.coordinate }

    init(listing: MapListing) {
        self.listing = listing
    }
}
