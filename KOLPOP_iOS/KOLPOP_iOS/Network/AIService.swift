//
//  AIService.swift
//  KOLPOP_iOS
//

import Foundation
import Moya

final class AIService {

    private let provider = MoyaProvider<AIAPI>(plugins: [MoyaLoggingPlugin()])

    func send(_ target: AIAPI, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {
                        completion(.failure(NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "AI 응답 형식이 올바르지 않습니다."])))
                        return
                    }

                    if let success = json["success"] as? Bool, !success {
                        let errorMessage = (json["error"] as? [String: Any])?["message"] as? String
                        completion(.failure(NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? "AI 서버에서 오류가 발생했습니다."])))
                        return
                    }

                    completion(.success(Self.extractDisplayText(from: json["data"])))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// data는 JsonNode(임의 JSON)라 정해진 스키마가 없다. 흔히 쓰일 법한 키를 순서대로
    /// 찾아보고, 없으면 원본 JSON을 그대로 텍스트로 보여준다. 실제 응답 형태를 확인한 뒤
    /// 이 로직을 정확한 필드 접근으로 교체해야 한다.
    private static func extractDisplayText(from data: Any?) -> String {
        if let dict = data as? [String: Any] {
            for key in ["message", "reply", "content", "text", "result", "answer"] {
                if let value = dict[key] as? String {
                    return value
                }
            }
        }
        if let string = data as? String {
            return string
        }
        guard let data,
              JSONSerialization.isValidJSONObject(data),
              let prettyData = try? JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return "AI 응답을 표시할 수 없습니다."
        }
        return prettyString
    }
}
