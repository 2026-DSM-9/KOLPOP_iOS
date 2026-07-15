//
//  FestivalAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum FestivalAPI {
    case list(page: Int, size: Int, keyword: String?, region: String?, from: String?, to: String?)
    case upcoming(limit: Int?)
}

extension FestivalAPI: TargetType {

    var baseURL: URL {
        Secrets.signUpAPIBaseURL
    }

    var path: String {
        switch self {
        case .list:
            return "/festivals"
        case .upcoming:
            return "/festivals/upcoming"
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case let .list(page, size, keyword, region, from, to):
            var parameters: [String: Any] = [
                "page": page,
                "size": size
            ]
            if let keyword, !keyword.isEmpty { parameters["keyword"] = keyword }
            if let region, !region.isEmpty { parameters["region"] = region }
            if let from, !from.isEmpty { parameters["from"] = from }
            if let to, !to.isEmpty { parameters["to"] = to }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case let .upcoming(limit):
            var parameters: [String: Any] = [:]
            if let limit { parameters["limit"] = limit }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? { nil }
}
