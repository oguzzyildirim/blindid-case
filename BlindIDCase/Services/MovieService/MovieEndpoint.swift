//
//  MovieEndpoint.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation

enum MovieEndpoint {
    case getMovies
    case getMovieDetail(movieId: Int)
}

extension MovieEndpoint: ApiEndpoint {
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
        case .getMovies:
            return "api/movies"
        case let .getMovieDetail(movieId):
            return "api/movies/\(movieId)"
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var params: [String: Any]? {
        return nil
    }

    var method: APIHTTPMethod {
        switch self {
        case .getMovies, .getMovieDetail:
            return .GET
        }
    }

    var customDataBody: Data? {
        return nil
    }
}
