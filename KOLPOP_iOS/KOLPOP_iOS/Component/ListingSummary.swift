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
