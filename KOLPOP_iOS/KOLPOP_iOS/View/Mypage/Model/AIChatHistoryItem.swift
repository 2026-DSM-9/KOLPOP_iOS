//
//  AIChatHistoryItem.swift
//  KOLPOP_iOS
//

import Foundation

struct AIChatHistoryItem {
    let id: String
    let title: String
    let lastMessagePreview: String
    let dateText: String
    let messages: [ChatMessage]
}
