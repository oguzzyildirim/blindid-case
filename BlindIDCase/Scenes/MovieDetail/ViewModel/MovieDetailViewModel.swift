//
//  MovieDetailViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    @Published var loginState: LoginState = .loggedOut
    @Published var showLoginAlert = false
    
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
        
        // Subscribe to login state changes - simple subscription
        authService.getCurrentLoginState()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.loginState = state
                if case .loggedIn = state {
                    self?.checkFavoriteStatus()
                }
            }
            .store(in: &cancellables)
        
        checkFavoriteStatus()
        fetchMovieDetail()
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
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        guard let movie = movie else { return }
        
        // Check if user is logged in
        if !loginState.isLoggedIn {
            // Show login alert instead of toggling favorite
            showLoginAlert = true
            return
        }
        
        isFavorite = favoriteService.toggleFavorite(movieId: movie.id)
    }
    
    private func checkFavoriteStatus() {
        // Only check favorites if logged in
        if loginState.isLoggedIn {
            isFavorite = favoriteService.isFavorite(movieId: movieId)
        } else {
            isFavorite = false
        }
    }
} 
