//
//  ExternalFestival.swift
//  KOLPOP_iOS
//
//  캘린더 화면 전용: 백엔드 자체 /festivals API가 아닌 공공데이터포털
//  전국문화축제표준데이터 API를 직접 호출해 사용한다.
//

import Foundation

struct ExternalFestival: Decodable {
    let fstvlNm: String
    let opar: String
    let fstvlStartDate: String
    let fstvlEndDate: String
    let fstvlCo: String
    let mnnstNm: String
    let rdnmadr: String
    let lnmadr: String
    let latitude: String
    let longitude: String
}

struct ExternalFestivalResponse: Decodable {
    let response: Body

    struct Body: Decodable {
        let header: Header
        let body: Result

        struct Header: Decodable {
            let resultCode: String
            let resultMsg: String
        }

        struct Result: Decodable {
            let items: [ExternalFestival]
            let totalCount: String
            let numOfRows: String
            let pageNo: String
        }
    }
}
