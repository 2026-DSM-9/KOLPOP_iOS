//
//  FestivalAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum FestivalAPI {
    case list(page: Int, numOfRows: Int, keyword: String?)
}

extension FestivalAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://api.data.go.kr/openapi/tn_pubr_public_cltur_fstvl_api")!
    }

    var path: String { "" }

    var method: Moya.Method { .get }

    var task: Task {
        var parameters: [String: Any] = [
            "serviceKey": "4e7dbed149deb89d084f0e46d42ff5f6c6a65cc094d56586b87e7a373f20d618",
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
