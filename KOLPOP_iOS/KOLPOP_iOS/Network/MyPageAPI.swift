//
//  MyPageAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum MyPageAPI {
    case fetch
}

extension MyPageAPI: TargetType {

    var baseURL: URL {
        Secrets.signUpAPIBaseURL
    }

    var path: String { "/mypage" }

    var method: Moya.Method { .get }

    var task: Task { .requestPlain }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let accessToken = TokenStore.shared.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        return headers
    }
}

final class MyPageService {

    private let provider = MoyaProvider<MyPageAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchMyPage(completion: @escaping (Result<MyPageResponse, Error>) -> Void) {
        provider.request(.fetch) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ApiResponse<MyPageResponse>.self, from: response.data)
                    guard let myPage = decoded.data else {
                        completion(.failure(NSError(domain: "MyPageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "마이페이지 응답이 올바르지 않습니다."])))
                        return
                    }
                    completion(.success(myPage))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
