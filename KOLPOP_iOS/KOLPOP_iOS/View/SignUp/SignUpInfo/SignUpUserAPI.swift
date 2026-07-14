//
//  SignUpUserAPI.swift
//  KOLPOP_iOS
//

import Foundation
import Moya
import Alamofire

enum AuthAPI {
    case signup(nickname: String, name: String, password: String, passwordConfirm: String, phone: String)
    case idCheck(loginId: String)
    case phoneNumber(phone: String)
    case phoneCheck(phone: String, code: String)
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        Secrets.signUpAPIBaseURL
    }

    var path: String {
        switch self {
        case .signup:
            return "auth/entrepreneur/signup"
        case .idCheck:
            return "auth/check-id"
        case .phoneNumber:
            return "auth/send"
        case .phoneCheck:
            return "auth/verify"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .signup(nickname, name, password, passwordConfirm, phone):
            let params: [String: Any] = [
                "loginId": nickname,
                "name": name,
                "password": password,
                "passwordConfirm": passwordConfirm,
                "phone": phone
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .idCheck(loginId):
            let params: [String: Any] = [
                "loginId": loginId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .phoneNumber(phone):
            let params: [String: Any] = [
                "phone": phone
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .phoneCheck(phone, code):
            let params: [String: Any] = [
                "phone": phone,
                "code": code
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
struct SignUpResponse: Codable {
    let success: Bool
    let data: SignUpData?
    let error: String?
}

struct SignUpData: Codable {
    let accessToken: String
    let expiresIn: Int
    let user: SignUpUser
}

struct SignUpUser: Codable {
    let userId: Int
    let phone: String
    let name: String
    let role: String
}

struct IDCheckResponse: Codable {
    let success: Bool
    let data: String?
}

final class AuthService {

    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])

    func signup(nickname: String, name: String, password: String, passwordConfirm: String, phone: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.signup(nickname: nickname, name: name, password: password, passwordConfirm: passwordConfirm, phone: phone)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 201 {
                    do {
                        let decoder = JSONDecoder()
                        let signUpResult = try decoder.decode(SignUpResponse.self, from: response.data)
                        print("회원가입 디코딩 성공! 토큰: \(signUpResult.data?.accessToken ?? "없음")")
                        completion(.success(signUpResult.success))
                    } catch {
                        print("🚨 성공 응답이지만 JSON 디코딩 실패: \(error)")
                        completion(.failure(error))
                    }
                }
                // 2️⃣ 404를 포함한 에러 코드(4xx, 5xx)일 때는 디코딩하지 않고 바로 실패 처리!
                else {
                    // 서버가 보내준 에러 메시지를 가볍게 스트링으로 찍어보기
                    if let rawResponseString = String(data: response.data, encoding: .utf8) {
                        print("서버 에러 바디 원본: \(rawResponseString)")
                    }
                    
                    let error = NSError(
                        domain: "SignupError",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "서버 연결 실패 (에러 코드: \(response.statusCode)) - 요청 경로(URL Path)를 다시 확인해 주세요!"]
                    )
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func checkID(loginId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.idCheck(loginId: loginId)) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    let error = NSError(
                        domain: "IDCheckError",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "아이디 중복 확인에 실패했습니다."]
                    )
                    completion(.failure(error))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(IDCheckResponse.self, from: response.data)
                    completion(.success(response.success))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func sendVerificationCode(phone: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.phoneNumber(phone: phone)) { result in
            self.handleAuthenticationResponse(result, errorDomain: "PhoneVerificationSendError", completion: completion)
        }
    }

    func verifyVerificationCode(phone: String, code: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.phoneCheck(phone: phone, code: code)) { result in
            self.handleAuthenticationResponse(result, errorDomain: "PhoneVerificationCheckError", completion: completion)
        }
    }

    private func handleAuthenticationResponse(
        _ result: Result<Response, MoyaError>,
        errorDomain: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        switch result {
        case .success(let response):
            guard response.statusCode == 200 else {
                let error = NSError(
                    domain: errorDomain,
                    code: response.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "전화번호 인증 요청에 실패했습니다."]
                )
                completion(.failure(error))
                return
            }

            do {
                let response = try JSONDecoder().decode(IDCheckResponse.self, from: response.data)
                completion(.success(response.success))
            } catch {
                completion(.failure(error))
            }

        case .failure(let error):
            completion(.failure(error))
        }
    }
}
