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
    case liked
    case like(listingId: Int)
    case unlike(listingId: Int)
    case addressSuggestions(keyword: String, limit: Int?)
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
        case .liked:
            return "/listings/liked"
        case .like(let listingId), .unlike(let listingId):
            return "/listings/\(listingId)/likes"
        case .addressSuggestions:
            return "/listings/address-suggestions"
        }
    }

    var method: Moya.Method {
        switch self {
        case .like:
            return .post
        case .unlike:
            return .delete
        default:
            return .get
        }
    }

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

        case .liked, .like, .unlike:
            return .requestPlain

        case let .addressSuggestions(keyword, limit):
            var parameters: [String: Any] = ["keyword": keyword]
            if let limit {
                parameters["limit"] = limit
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        guard let accessToken = TokenStore.shared.accessToken else { return nil }
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
