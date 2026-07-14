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

    /// 서버가 초 단위 응답과 밀리초/마이크로초 포함 응답을 섞어 보내는 경우가 있어 여러 포맷을 순서대로 시도한다.
    private static let apiDateFormatters: [DateFormatter] = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss"
    ].map {
        let formatter = DateFormatter()
        formatter.dateFormat = $0
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }

    private static func parseAPIDate(_ string: String) -> Date? {
        for formatter in apiDateFormatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        return nil
    }

    private static let displayTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    static var currentTimestampText: String {
        displayTimeFormatter.string(from: Date())
    }

    init(response: ChatMessageResponse) {
        sender = response.sender.id == TokenStore.shared.currentUserId ? .me : .other
        content = .text(response.content)
        if let date = Self.parseAPIDate(response.createdAt) {
            timestamp = Self.displayTimeFormatter.string(from: date)
        } else {
            timestamp = response.createdAt
        }
    }
}
