//
//  ChatRoom.swift
//  KOLPOP_iOS
//

import Foundation

enum ChatStatus {
    case inProgress
    case completed
    case rejected

    var listBadgeText: String {
        switch self {
        case .inProgress: return "진행중"
        case .completed: return "완료"
        case .rejected: return "거절"
        }
    }

    var detailBadgeText: String {
        switch self {
        case .inProgress: return "진행중"
        case .completed: return "계약완료"
        case .rejected: return "거절"
        }
    }

    var backgroundColorName: String {
        switch self {
        case .inProgress: return "BFEBFB"
        case .completed: return "FAE2C8"
        case .rejected: return "E8E8E8"
        }
    }

    var textColorName: String {
        switch self {
        case .inProgress: return "00688F"
        case .completed: return "8C5414"
        case .rejected: return "767778"
        }
    }
}

extension ChatStatus {

    /// 실서버의 status 문자열 값이 정확히 뭔지 확인되지 않아, 값에 특정 단어가 포함되는지로
    /// 느슨하게 매핑한다. 실제 값 확인 후 정확한 매핑으로 교체가 필요할 수 있다.
    init(rawServerValue: String) {
        let value = rawServerValue.uppercased()
        if value.contains("REJECT") {
            self = .rejected
        } else if value.contains("COMPLETE") || value.contains("ACCEPT") {
            self = .completed
        } else {
            self = .inProgress
        }
    }
}

struct ChatRoom {
    let id: String
    let imageURL: URL?
    let title: String
    let lastMessage: String
    let senderName: String
    let status: ChatStatus
    let unreadCount: Int
}

extension ChatRoom {

    /// ChatRoomResponse에는 최근 메시지/안읽음 개수 정보가 없어 기본값으로 채운다.
    /// 방이 이제 매물 기준으로 생성되므로 제목은 매물명을 사용한다.
    init(response: ChatRoomResponse) {
        let counterpart = response.founder.id == TokenStore.shared.currentUserId ? response.landlord : response.founder
        id = String(response.roomId)
        imageURL = response.listing.thumbnailUrl.flatMap(URL.init(string:))
        title = response.listing.title
        lastMessage = ""
        senderName = counterpart.name
        status = ChatStatus(rawServerValue: response.status)
        unreadCount = 0
    }
}
