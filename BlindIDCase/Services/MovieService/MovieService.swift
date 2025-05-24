//
//  MovieService.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation
import Combine

protocol MovieServiceProtocol {
    func fetchMovies() -> AnyPublisher<MoviesResponse, Error>
    func fetchMovieDetail(id: Int) -> AnyPublisher<Movie, Error>
}

final class MovieService: MovieServiceProtocol {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }
    
    func fetchMovies() -> AnyPublisher<MoviesResponse, Error> {
        let request = MovieEndpoint.getMovies.makeRequest
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    throw NSError(domain: "MovieService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "API Error: \(response.statusCode)"])
                }
                return data
            }
            .decode(type: MoviesResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(id: Int) -> AnyPublisher<Movie, Error> {
        let request = MovieEndpoint.getMovieDetail(movieId: id).makeRequest
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    throw NSError(domain: "MovieService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "API Error: \(response.statusCode)"])
                }
                return data
            }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
} 
