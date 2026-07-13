//
//  Festival.swift
//  KOLPOP_iOS
//

import Foundation

struct Festival: Decodable {
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

struct FestivalResponse: Decodable {
    let response: Body

    struct Body: Decodable {
        let header: Header
        let body: Result

        struct Header: Decodable {
            let resultCode: String
            let resultMsg: String
        }

        struct Result: Decodable {
            let items: [Festival]
            let totalCount: String
            let numOfRows: String
            let pageNo: String
        }
    }
}
