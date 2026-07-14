//
//  ListingAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum ListingAPI {
    case list(keyword: String?)
    case detail(listingId: Int)
    case discovery(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, keyword: String?)
    case map(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, keyword: String?)
}

extension ListingAPI: TargetType {

    var baseURL: URL {
        Secrets.signUpAPIBaseURL
    }

    var path: String {
        switch self {
        case .list:
            return "/listings"
        case .detail(let listingId):
            return "/listings/\(listingId)"
        case .discovery:
            return "/listings/discovery"
        case .map:
            return "/listings/map"
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case .list(let keyword):
            var parameters: [String: Any] = [:]
            if let keyword, !keyword.isEmpty {
                parameters["keyword"] = keyword
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .detail:
            return .requestPlain

        case .discovery(let minLatitude, let maxLatitude, let minLongitude, let maxLongitude, let keyword):
            var parameters: [String: Any] = [
                "minLatitude": minLatitude,
                "maxLatitude": maxLatitude,
                "minLongitude": minLongitude,
                "maxLongitude": maxLongitude
            ]
            if let keyword, !keyword.isEmpty {
                parameters["keyword"] = keyword
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .map(let minLatitude, let maxLatitude, let minLongitude, let maxLongitude, let keyword):
            var parameters: [String: Any] = [
                "minLatitude": minLatitude,
                "maxLatitude": maxLatitude,
                "minLongitude": minLongitude,
                "maxLongitude": maxLongitude
            ]
            if let keyword, !keyword.isEmpty {
                parameters["keyword"] = keyword
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? { nil }
}
