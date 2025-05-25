//
//  FavoriteEndpoint.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 24.05.2025.
//

import Foundation

enum FavoriteEndpoint {
    case likeMovie(movieId: Int)
    case unlikeMovie(movieId: Int)
}

extension FavoriteEndpoint: ApiEndpoint {
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
        case .likeMovie(let movieId):
            return "api/movies/like/\(movieId)"
        case .unlikeMovie(let movieId):
            return "api/movies/unlike/\(movieId)"
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        
        switch self {
        case .likeMovie, .unlikeMovie:
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                headers["Authorization"] = "Bearer \(token)"
            } else {
                LogManager.shared.error("AuthEndpoint: No token found for Authorization header")
            }
        }
        
        return headers
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var params: [String: Any]? {
        switch self {
        case .likeMovie, .unlikeMovie:
            return nil
        }
    }
    
    var method: APIHTTPMethod {
        switch self {
        case .likeMovie, .unlikeMovie:
            return .POST
        }
    }
    
    var customDataBody: Data? {
        return nil
    }
}
