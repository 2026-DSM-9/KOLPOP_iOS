//
//  ListingDetailInfo.swift
//  KOLPOP_iOS
//

import Foundation

struct ListingDetailInfo {
    let title: String
    let address: String
    let landlordName: String
    let tags: [String]
    let deposit: String
    let dailyPrice: String
    let area: String
    let availablePeriod: String
    let operatingDaysInfo: String
    let facilities: [String]
    let businessRestrictions: [String]
    let description: String
    /// 목업 데이터 표시용 로컬 이미지 에셋 이름. 실제 API 응답은 imageURLs를 사용한다.
    let imageNames: [String]
    let imageURLs: [URL]

    static let mock = ListingDetailInfo(
        title: "대덕소프트웨어마이스터고",
        address: "대전광역시 가정북로 72",
        landlordName: "김임대",
        tags: ["#유동인구많음", "#코너자리", "#대로변"],
        deposit: "5,000,000원",
        dailyPrice: "150,000원",
        area: "59.5m²",
        availablePeriod: "2026.07.24 - 2026.08.09",
        operatingDaysInfo: "최소 3일 ~ 최대 18일",
        facilities: ["와이파이", "에어컨", "화장실", "주방", "수도", "주차 3대 가능"],
        businessRestrictions: ["소음 업종 불가", "유흥업소 불가"],
        description: "소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다",
        imageNames: ["Festival", "Festival", "Festival"],
        imageURLs: []
    )
}

extension ListingDetailInfo {

    init(response: ListingDetailResponse) {
        title = response.title
        address = response.detailAddress.map { "\(response.address) \($0)" } ?? response.address
        landlordName = response.landlordName
        tags = response.hashtags
        deposit = "\(response.deposit.formattedWithComma)원"
        dailyPrice = "\(response.dailyFee.formattedWithComma)원"
        area = String(format: "%.1fm²", response.area)
        availablePeriod = "\(response.operatingStartDate.replacingOccurrences(of: "-", with: ".")) - \(response.operatingEndDate.replacingOccurrences(of: "-", with: "."))"
        operatingDaysInfo = "최소 \(response.minOperatingDays)일 ~ 최대 \(response.maxOperatingDays)일"
        facilities = response.facilities
        businessRestrictions = response.industryRestrictions + response.additionalRestrictions
        description = response.description
        imageNames = []
        imageURLs = response.imageUrls.compactMap(URL.init(string:))
    }
}
