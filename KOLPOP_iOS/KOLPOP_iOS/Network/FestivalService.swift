//
//  FestivalService.swift
//  KOLPOP_iOS
//

import Foundation
import Moya

final class FestivalService {

    private let provider = MoyaProvider<FestivalAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchFestivals(page: Int = 1, numOfRows: Int = 30, keyword: String? = nil, completion: @escaping (Result<[Festival], Error>) -> Void) {
        provider.request(.list(page: page, numOfRows: numOfRows, keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(FestivalResponse.self, from: response.data)
                    completion(.success(decoded.response.body.items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
