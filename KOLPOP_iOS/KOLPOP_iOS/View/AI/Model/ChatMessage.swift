//
//  ChatMessage.swift
//  KOLPOP_iOS
//

import Foundation

struct ChatMessage {
    enum Sender {
        case ai
        case user
    }

    let sender: Sender
    var text: String
    var showCopyButton: Bool = false
    var isTyping: Bool = false
}
