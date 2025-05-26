//
//  MovieDetailViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation
import Combine
import SwiftUI

final class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    @Published var showLoginAlert = false
    
    @AppStorage(StaticKeys.loginStatus.key) var isLoggedIn: Bool = false
    
    private let movieId: Int
    private let movieService: MovieServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, 
         movieService: MovieServiceProtocol = MovieService(),
         favoriteService: FavoriteServiceProtocol = FavoriteService(),
         authService: AuthServiceProtocol = AuthService()) {
        self.movieId = movieId
        self.movieService = movieService
        self.favoriteService = favoriteService
        self.authService = authService
        
        setupLoginStateObserver()
        
        checkFavoriteStatus()
        fetchMovieDetail()
    }
    
    private func setupLoginStateObserver() {
        authService.getCurrentLoginState()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.isLoggedIn = state.isLoggedIn
                self.checkFavoriteStatus()
            }
            .store(in: &cancellables)
    }
    
    func fetchMovieDetail() {
        isLoading = true
        errorMessage = nil
        
        movieService.fetchMovieDetail(id: movieId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movie in
                self?.movie = movie
                self?.checkFavoriteStatus()
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        guard let movie = movie, let movieId = movie.id else { return }
        
        guard isLoggedIn else {
            showLoginAlert = true
            return
        }
        
        if isFavorite {
            favoriteService.unlikeMovie(movieId: movieId)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("Error unliking movie: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] _ in
                    self?.isFavorite = false
                }
                .store(in: &cancellables)
        } else {
            favoriteService.likeMovie(movieId: movieId)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("Error liking movie: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] _ in
                    self?.isFavorite = true
                }
                .store(in: &cancellables)
        }
    }
    
    private func checkFavoriteStatus() {
        isFavorite = favoriteService.isMovieLiked(movieId: movieId)
    }
}
