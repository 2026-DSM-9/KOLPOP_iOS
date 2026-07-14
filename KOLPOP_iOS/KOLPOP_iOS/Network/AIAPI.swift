//
//  AIAPI.swift
//  KOLPOP_iOS
//
//  주의: /ai/* 엔드포인트는 swagger 상 요청/응답이 전부 JsonNode(임의 JSON)로만
//  문서화되어 있어 실제 필드 이름을 알 수 없다. 아래 {"message": ...} 요청 형태와
//  응답에서 추출하는 키 목록(AIService.extractDisplayText)은 추측이며, 서버 배포가
//  끝나면 실제 응답을 보고 반드시 다시 확인해야 한다.
//

import Foundation
import Moya
import Alamofire

enum AIAPI {
    case recommendRegions(message: String)
    case recommendListings(message: String)
    case recommendBusinessItems(message: String)
    case marketingAutomation(message: String)
    case chatListings(message: String)
    case health
}

extension AIAPI: TargetType {

    var baseURL: URL {
        Secrets.aiAPIBaseURL
    }

    var path: String {
        switch self {
        case .recommendRegions:
            return "/ai/recommend/regions"
        case .recommendListings:
            return "/ai/recommend/listings"
        case .recommendBusinessItems:
            return "/ai/recommend/business-items"
        case .marketingAutomation:
            return "/ai/marketing/automation"
        case .chatListings:
            return "/ai/chat/listings"
        case .health:
            return "/ai/health"
        }
    }

    var method: Moya.Method {
        switch self {
        case .health:
            return .get
        default:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .health:
            return .requestPlain
        case let .recommendRegions(message), let .recommendListings(message), let .recommendBusinessItems(message), let .marketingAutomation(message), let .chatListings(message):
            return .requestParameters(parameters: ["message": message], encoding: JSONEncoding.default)
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
