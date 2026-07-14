//
//  TokenStore.swift
//  KOLPOP_iOS
//

import Foundation

/// 로그인 API 연동 전까지는 accessToken/currentUserId가 채워지지 않는다.
/// 로그인 연동 시 이 저장소에 값을 채워 넣으면 채팅 소켓/REST 인증에서 그대로 사용된다.
final class TokenStore {

    static let shared = TokenStore()

    private let defaults = UserDefaults.standard
    private let accessTokenKey = "accessToken"
    private let currentUserIdKey = "currentUserId"

    private init() {}

    var accessToken: String? {
        get { defaults.string(forKey: accessTokenKey) }
        set { defaults.set(newValue, forKey: accessTokenKey) }
    }

    var currentUserId: Int? {
        get {
            let value = defaults.integer(forKey: currentUserIdKey)
            return defaults.object(forKey: currentUserIdKey) == nil ? nil : value
        }
        set { defaults.set(newValue, forKey: currentUserIdKey) }
    }
}
