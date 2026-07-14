//
//  UserProfile.swift
//  KOLPOP_iOS
//

import Foundation

struct UserProfile {
    var name: String
    var phoneNumber: String
    var email: String = ""
    var introduction: String = ""

    // TODO: 회원가입/정보 수정 API 연동 전까지는 목업 데이터를 사용한다.
    static let mock = UserProfile(name: "하원", phoneNumber: "010-9781-8851")
}
