//
//  ChatModels.swift
//  KOLPOP_iOS
//

import Foundation

struct ChatUserResponse: Decodable {
    let id: Int
    let name: String
    let role: String
}

struct ChatMessageResponse: Decodable {
    let messageId: Int
    let roomId: Int
    let sender: ChatUserResponse
    let content: String
    let createdAt: String
}

struct ChatRoomResponse: Decodable {
    let roomId: Int
    let founder: ChatUserResponse
    let landlord: ChatUserResponse
    let createdAt: String
}

struct ChatSendMessageRequest: Encodable {
    let content: String
}
