//
//  ExternalFestivalService.swift
//  KOLPOP_iOS
//

import Foundation
import Moya

final class ExternalFestivalService {

    private let provider = MoyaProvider<ExternalFestivalAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchFestivals(page: Int = 1, numOfRows: Int = 30, keyword: String? = nil, completion: @escaping (Result<[ExternalFestival], Error>) -> Void) {
        provider.request(.list(page: page, numOfRows: numOfRows, keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ExternalFestivalResponse.self, from: response.data)
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
