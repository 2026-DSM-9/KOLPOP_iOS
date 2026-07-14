//
//  ChatDetailMessage.swift
//  KOLPOP_iOS
//

import Foundation

struct ChatDetailMessage {
    enum Sender {
        case me
        case other
    }

    enum Content {
        case text(String)
        case image(String)
    }

    let sender: Sender
    let content: Content
    let timestamp: String
}
