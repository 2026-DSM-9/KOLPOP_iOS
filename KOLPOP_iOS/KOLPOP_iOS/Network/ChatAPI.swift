//
//  ChatAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum ChatAPI {
    case rooms
    case createRoom(listingId: Int, content: String)
    case messages(roomId: Int)
}

extension ChatAPI: TargetType {

    var baseURL: URL {
        Secrets.signUpAPIBaseURL
    }

    var path: String {
        switch self {
        case .rooms, .createRoom:
            return "/chat/rooms"
        case .messages(let roomId):
            return "/chat/rooms/\(roomId)/messages"
        }
    }

    var method: Moya.Method {
        switch self {
        case .rooms, .messages:
            return .get
        case .createRoom:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .rooms, .messages:
            return .requestPlain
        case let .createRoom(listingId, content):
            return .requestParameters(parameters: ["listingId": listingId, "content": content], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let accessToken = TokenStore.shared.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        return headers
    }
}

final class ChatService {

    private let provider = MoyaProvider<ChatAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchRooms(completion: @escaping (Result<[ChatRoomResponse], Error>) -> Void) {
        provider.request(.rooms) { result in
            completion(Self.decode([ChatRoomResponse].self, from: result))
        }
    }

    func createRoom(listingId: Int, content: String, completion: @escaping (Result<ChatRoomResponse, Error>) -> Void) {
        provider.request(.createRoom(listingId: listingId, content: content)) { result in
            completion(Self.decode(ChatRoomResponse.self, from: result))
        }
    }

    func fetchMessages(roomId: Int, completion: @escaping (Result<[ChatMessageResponse], Error>) -> Void) {
        provider.request(.messages(roomId: roomId)) { result in
            completion(Self.decode([ChatMessageResponse].self, from: result))
        }
    }

    private static func decode<T: Decodable>(_ type: T.Type, from result: Result<Response, MoyaError>) -> Result<T, Error> {
        switch result {
        case .success(let response):
            do {
                let decoded = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
                guard let data = decoded.data else {
                    return .failure(NSError(domain: "ChatService", code: -1, userInfo: [NSLocalizedDescriptionKey: "응답 데이터가 없습니다."]))
                }
                return .success(data)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
