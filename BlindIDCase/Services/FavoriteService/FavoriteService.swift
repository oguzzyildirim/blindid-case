//
//  FavoriteService.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation
import Combine

// MARK: - Favorite Service Protocol

protocol FavoriteServiceProtocol {
    func likeMovie(movieId: Int) -> AnyPublisher<Void, Error>
    func unlikeMovie(movieId: Int) -> AnyPublisher<Void, Error>
    func isMovieLiked(movieId: Int) -> Bool
    func getLikedMovies() -> [Int]
}

final class FavoriteService: FavoriteServiceProtocol {
    private let httpClient: HTTPClient
    private let authService: AuthServiceProtocol
    private var currentLoginState: LoginState = .loggedOut
    private var cancellables = Set<AnyCancellable>()
    
    init(httpClient: HTTPClient = URLSession.shared, authService: AuthServiceProtocol = AuthService()) {
        self.httpClient = httpClient
        self.authService = authService
        
        authService.getCurrentLoginState()
            .sink { [weak self] state in
                self?.currentLoginState = state
            }
            .store(in: &cancellables)
    }
    
    func likeMovie(movieId: Int) -> AnyPublisher<Void, Error> {
        guard authService.isUserLoggedIn() else {
            return Fail(error: NSError(domain: "FavoriteService", code: 401,
                                       userInfo: [NSLocalizedDescriptionKey: "User must be logged in to like a movie"]))
                .eraseToAnyPublisher()
        }
        
        let request = FavoriteEndpoint.likeMovie(movieId: movieId).makeRequest
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    let errorMessage = "Failed to like movie: \(response.statusCode)"
                    throw NSError(domain: "FavoriteService", code: response.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func unlikeMovie(movieId: Int) -> AnyPublisher<Void, Error> {
        // Giriş yapılmış olması kontrol edilir
        guard authService.isUserLoggedIn() else {
            return Fail(error: NSError(domain: "FavoriteService", code: 401,
                                       userInfo: [NSLocalizedDescriptionKey: "User must be logged in to unlike a movie"]))
                .eraseToAnyPublisher()
        }
        
        let request = FavoriteEndpoint.unlikeMovie(movieId: movieId).makeRequest
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    let errorMessage = "Failed to unlike movie: \(response.statusCode)"
                    throw NSError(domain: "FavoriteService", code: response.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func isMovieLiked(movieId: Int) -> Bool {
        guard case .loggedIn(let user) = currentLoginState else {
            return false
        }
        
        return user.likedMovies.contains(movieId)
    }
    
    func getLikedMovies() -> [Int] {
        guard case .loggedIn(let user) = currentLoginState else {
            return []
        }
        
        return user.likedMovies
    }
}
