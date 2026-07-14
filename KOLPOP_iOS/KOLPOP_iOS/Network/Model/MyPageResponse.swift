//
//  MyPageResponse.swift
//  KOLPOP_iOS
//

import Foundation

struct MyPageResponse: Decodable {
    let name: String
    let email: String
    let phone: String
    let introduction: String
    let role: String
}
