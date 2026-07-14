//
//  ChatDetailMessage.swift
//  KOLPOP_iOS
//

import UIKit

struct ChatDetailMessage {
    enum Sender {
        case me
        case other
    }

    enum Content {
        /// 데모용 목업 메시지에서 사용하는 로컬 에셋 이미지
        case image(String)
        /// 사용자가 사진 피커로 직접 선택해 보낸 이미지
        case pickedImage(UIImage)
        case text(String)
    }

    let sender: Sender
    let content: Content
    let timestamp: String
}

extension ChatDetailMessage {

    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    private static let displayTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        return formatter
    }()

    static var currentTimestampText: String {
        displayTimeFormatter.string(from: Date())
    }

    init(response: ChatMessageResponse) {
        sender = response.sender.id == TokenStore.shared.currentUserId ? .me : .other
        content = .text(response.content)
        if let date = Self.apiDateFormatter.date(from: response.createdAt) {
            timestamp = Self.displayTimeFormatter.string(from: date)
        } else {
            timestamp = response.createdAt
        }
    }
}
