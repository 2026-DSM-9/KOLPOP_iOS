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
