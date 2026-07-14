//
//  ChatSocketService.swift
//  KOLPOP_iOS
//

import Foundation

final class ChatSocketService {

    private let socketURL = URL(string: "ws://43.201.99.20:8080/ws/chat")!
    private let stompClient = StompClient()
    private var pendingSubscription: (roomId: Int, onMessage: (ChatMessageResponse) -> Void)?

    func connectAndSubscribe(roomId: Int, onMessage: @escaping (ChatMessageResponse) -> Void, onError: @escaping (Error) -> Void) {
        pendingSubscription = (roomId, onMessage)

        var headers: [String: String] = [:]
        if let accessToken = TokenStore.shared.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }

        stompClient.connect(url: socketURL, headers: headers, onConnected: { [weak self] in
            guard let self, let pending = self.pendingSubscription else { return }
            self.stompClient.subscribe(destination: "/topic/chat/rooms/\(pending.roomId)") { payload in
                guard let data = payload.data(using: .utf8),
                      let message = try? JSONDecoder().decode(ChatMessageResponse.self, from: data) else { return }
                pending.onMessage(message)
            }
        }, onError: onError)
    }

    func sendMessage(roomId: Int, content: String) {
        guard let data = try? JSONEncoder().encode(ChatSendMessageRequest(content: content)),
              let body = String(data: data, encoding: .utf8) else { return }
        stompClient.send(destination: "/app/chat/rooms/\(roomId)/messages", body: body)
    }

    func disconnect() {
        stompClient.disconnect()
        pendingSubscription = nil
    }
}
