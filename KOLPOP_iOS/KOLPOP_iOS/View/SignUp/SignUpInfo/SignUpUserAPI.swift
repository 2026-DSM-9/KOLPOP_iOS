import Foundation
import Moya
import Alamofire
enum AuthAPI {
    case signup(nickname: String, name: String, password: String, passwordConfirm: String, phone: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return Secrets.signUpAPIBaseURL
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/api/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .signup(nickname, name, password, passwordConfirm, phone):
            let params: [String: Any] = [
                "nickname": nickname,
                "name": name,
                "password": password,
                "passwordConfirm": passwordConfirm,
                "phone": phone
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

final class AuthService {
    private let provider = MoyaProvider<AuthAPI>()
    
    func signup(nickname: String, name: String, password: String, passwordConfirm: String, phone: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.signup(nickname: nickname, name: name, password: password, passwordConfirm: passwordConfirm, phone: phone)) { result in
            switch result {
            case .success(let response):
                // 201 Created 성공 처리
                if response.statusCode == 201 {
                    completion(.success(true))
                } else {
                    let error = NSError(domain: "SignupError", code: response.statusCode, userInfo: nil)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
