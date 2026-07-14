//
//  ListingService.swift
//  KOLPOP_iOS
//

import Foundation
import Moya

final class ListingService {

    private let provider = MoyaProvider<ListingAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchListings(keyword: String? = nil, completion: @escaping (Result<[ListingSummaryResponse], Error>) -> Void) {
        provider.request(.list(keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ApiResponse<ListingListResponse>.self, from: response.data)
                    completion(.success(decoded.data?.listings ?? []))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
