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

    func fetchMapListings(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, keyword: String? = nil, completion: @escaping (Result<[ListingMapItemResponse], Error>) -> Void) {
        provider.request(.map(minLatitude: minLatitude, maxLatitude: maxLatitude, minLongitude: minLongitude, maxLongitude: maxLongitude, keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ApiResponse<ListingMapResponse>.self, from: response.data)
                    completion(.success(decoded.data?.listings ?? []))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDiscovery(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, keyword: String? = nil, completion: @escaping (Result<ListingDiscoveryResponse, Error>) -> Void) {
        provider.request(.discovery(minLatitude: minLatitude, maxLatitude: maxLatitude, minLongitude: minLongitude, maxLongitude: maxLongitude, keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ApiResponse<ListingDiscoveryResponse>.self, from: response.data)
                    guard let discovery = decoded.data else {
                        completion(.failure(NSError(domain: "ListingService", code: -1, userInfo: [NSLocalizedDescriptionKey: "지도 매물 탐색 응답이 올바르지 않습니다."])))
                        return
                    }
                    completion(.success(discovery))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDetail(listingId: Int, completion: @escaping (Result<ListingDetailResponse, Error>) -> Void) {
        provider.request(.detail(listingId: listingId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ApiResponse<ListingDetailResponse>.self, from: response.data)
                    guard let detail = decoded.data else {
                        completion(.failure(NSError(domain: "ListingService", code: -1, userInfo: [NSLocalizedDescriptionKey: "매물 상세 응답이 올바르지 않습니다."])))
                        return
                    }
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
