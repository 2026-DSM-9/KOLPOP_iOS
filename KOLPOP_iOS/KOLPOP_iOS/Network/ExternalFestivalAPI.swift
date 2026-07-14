//
//  ExternalFestivalAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum ExternalFestivalAPI {
    case list(page: Int, numOfRows: Int, keyword: String?)
}

extension ExternalFestivalAPI: TargetType {

    var baseURL: URL {
        Secrets.festivalAPIBaseURL
    }

    var path: String { "" }

    var method: Moya.Method { .get }

    var task: Task {
        var parameters: [String: Any] = [
            "serviceKey": Secrets.festivalAPIServiceKey,
            "type": "json"
        ]

        switch self {
        case .list(let page, let numOfRows, let keyword):
            parameters["pageNo"] = page
            parameters["numOfRows"] = numOfRows
            if let keyword, !keyword.isEmpty {
                parameters["fstvlNm"] = keyword
            }
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var headers: [String: String]? { nil }
}
