//
//  StompClient.swift
//  KOLPOP_iOS
//
//  SockJS 없이 순수 WebSocket 위에서 동작하는 최소 STOMP 1.2 클라이언트.
//  서버 스펙: ws://43.201.99.20:8080/ws/chat, CONNECT 헤더로 Authorization: Bearer {accessToken} 전달.
//

import Foundation

final class StompClient: NSObject {

    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var subscriptionHandlers: [String: (String) -> Void] = [:]
    private var subscriptionCounter = 0

    private var onConnected: (() -> Void)?
    private var onError: ((Error) -> Void)?

    func connect(url: URL, headers: [String: String], onConnected: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.onConnected = onConnected
        self.onError = onError

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        self.urlSession = session
        let task = session.webSocketTask(with: url)
        self.webSocketTask = task
        task.resume()

        listen()

        var connectHeaders = headers
        connectHeaders["accept-version"] = "1.2"
        connectHeaders["heart-beat"] = "0,0"
        connectHeaders["host"] = url.host ?? ""
        sendFrame(command: "CONNECT", headers: connectHeaders, body: nil)
    }

    func subscribe(destination: String, onMessage: @escaping (String) -> Void) {
        subscriptionCounter += 1
        let subscriptionId = "sub-\(subscriptionCounter)"
        subscriptionHandlers[subscriptionId] = onMessage
        sendFrame(command: "SUBSCRIBE", headers: ["id": subscriptionId, "destination": destination], body: nil)
    }

    func send(destination: String, body: String) {
        sendFrame(command: "SEND", headers: ["destination": destination, "content-type": "application/json"], body: body)
    }

    func disconnect() {
        sendFrame(command: "DISCONNECT", headers: [:], body: nil)
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil
        subscriptionHandlers.removeAll()
    }

    private func sendFrame(command: String, headers: [String: String], body: String?) {
        var frame = command + "\n"
        for (key, value) in headers {
            frame += "\(key):\(value)\n"
        }
        frame += "\n"
        if let body {
            frame += body
        }
        frame += "\u{00}"

        webSocketTask?.send(.string(frame)) { [weak self] error in
            if let error {
                self?.onError?(error)
            }
        }
    }

    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleFrame(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.handleFrame(text)
                    }
                @unknown default:
                    break
                }
                self.listen()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }

    private func handleFrame(_ raw: String) {
        let frame = raw.trimmingCharacters(in: CharacterSet(charactersIn: "\u{00}"))
        guard !frame.isEmpty else { return }

        let parts = frame.components(separatedBy: "\n\n")
        let headerBlock = parts[0]
        let body = parts.count > 1 ? parts[1...].joined(separator: "\n\n") : ""

        var lines = headerBlock.components(separatedBy: "\n")
        guard !lines.isEmpty else { return }
        let command = lines.removeFirst()

        var headers: [String: String] = [:]
        for line in lines {
            guard let separatorIndex = line.firstIndex(of: ":") else { continue }
            let key = String(line[line.startIndex..<separatorIndex])
            let value = String(line[line.index(after: separatorIndex)...])
            headers[key] = value
        }

        switch command {
        case "CONNECTED":
            onConnected?()
        case "MESSAGE":
            if let subscriptionId = headers["subscription"], let handler = subscriptionHandlers[subscriptionId] {
                handler(body)
            }
        case "ERROR":
            let message = headers["message"] ?? "STOMP 오류"
            onError?(NSError(domain: "StompClient", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
        default:
            break
        }
    }
}
