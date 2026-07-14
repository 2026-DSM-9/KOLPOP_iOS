//
//  FestivalService.swift
//  KOLPOP_iOS
//

import Foundation
import Moya

final class FestivalService {

    private let provider = MoyaProvider<FestivalAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchFestivals(page: Int = 1, size: Int = 30, keyword: String? = nil, region: String? = nil, from: String? = nil, to: String? = nil, completion: @escaping (Result<[Festival], Error>) -> Void) {
        provider.request(.list(page: page, size: size, keyword: keyword, region: region, from: from, to: to)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ApiResponse<FestivalListResponse>.self, from: response.data)
                    guard let listResponse = decoded.data else {
                        completion(.success([]))
                        return
                    }
                    completion(.success(listResponse.festivals.map(Festival.init(summary:))))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
