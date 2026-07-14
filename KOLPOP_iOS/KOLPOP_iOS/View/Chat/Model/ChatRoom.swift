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

    /// ChatRoomResponse에는 상태/최근 메시지/안읽음 개수 정보가 없어 기본값으로 채운다.
    init(response: ChatRoomResponse) {
        let counterpart = response.founder.id == TokenStore.shared.currentUserId ? response.landlord : response.founder
        id = String(response.roomId)
        imageURL = nil
        title = counterpart.name
        lastMessage = ""
        senderName = counterpart.name
        status = .inProgress
        unreadCount = 0
    }
}
