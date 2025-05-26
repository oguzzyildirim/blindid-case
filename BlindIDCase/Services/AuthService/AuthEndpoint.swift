//
//  AuthEndpoint.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation

enum AuthEndpoint {
    case register(name: String, surname: String, email: String, password: String)
    case update(name: String, surname: String, email: String, password: String)
    case login(email: String, password: String)
    case me
}

extension AuthEndpoint: ApiEndpoint {
    var baseURLString: String {
        return API.baseURL
    }
    
    var apiVersion: String? {
        return nil
    }
    
    var separatorPath: String? {
        return nil
    }
    
    var path: String {
        switch self {
        case .register:
            return "api/auth/register"
        case .update:
            return "api/users/profile"
        case .login:
            return "api/auth/login"
        case .me:
            return "api/auth/me"
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        
        switch self {
        case .me, .update:
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                headers["Authorization"] = "Bearer \(token)"
                LogManager.shared.info("AuthEndpoint: Adding Authorization header with token: \(token.prefix(10))...")
            } else {
                LogManager.shared.warning("AuthEndpoint: No token found for Authorization header")
            }
        default:
            break
        }
        
        return headers
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var params: [String: Any]? {
        switch self {
        case .register(let name, let surname, let email, let password):
            let params = [
                "name": name,
                "surname": surname,
                "email": email,
                "password": password
            ]
            LogManager.shared.info("AuthEndpoint: Update params: \(name), \(surname), \(email), [password]")
            return params
            
        case .update(let name, let surname, let email, let password):
            let params = [
                "name": name,
                "surname": surname,
                "email": email,
                "password": password
            ]
            LogManager.shared.info("AuthEndpoint: Register params: \(name), \(surname), \(email), [password]")
            return params
            
        case .login(let email, let password):
            let params = [
                "email": email,
                "password": password
            ]
            LogManager.shared.info("AuthEndpoint: Login params: \(email), [password]")
            return params
            
        case .me:
            return nil
        }
    }
    
    var method: APIHTTPMethod {
        switch self {
        case .register, .login:
            return .POST
        case .update:
            return .PUT
        case .me:
            return .GET
        }
    }
    
    var customDataBody: Data? {
        return nil
    }
}
