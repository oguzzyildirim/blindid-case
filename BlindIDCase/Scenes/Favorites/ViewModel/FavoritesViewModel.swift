//
//  FavoritesViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation
import Combine
import SwiftUI

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @AppStorage(StaticKeys.loginStatus.key) private var isLoggedIn: Bool = false
    
    private let movieService: MovieServiceProtocol
    private let authService: AuthServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movieService: MovieServiceProtocol = MovieService(),
         authService: AuthServiceProtocol = AuthService(),
         favoriteService: FavoriteServiceProtocol = FavoriteService()) {
        self.movieService = movieService
        self.authService = authService
        self.favoriteService = favoriteService
        
        setupLoginStateObserver()
    }
    
    private func setupLoginStateObserver() {
        authService.getCurrentLoginState()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                self.isLoggedIn = state.isLoggedIn
                
                if state.isLoggedIn {
                    self.fetchFavoriteMovies()
                } else {
                    self.favoriteMovies = []
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchFavoriteMovies() {
        guard isLoggedIn else {
            self.favoriteMovies = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        authService.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                guard let self = self else { return }
                
                let movieIds = user.likedMovies
                
                if movieIds.isEmpty {
                    self.isLoading = false
                    self.favoriteMovies = []
                    return
                }
                
                self.movieService.fetchMovies()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        self.isLoading = false
                        
                        if case .failure(let error) = completion {
                            self.errorMessage = error.localizedDescription
                        }
                    } receiveValue: { movies in
                        self.favoriteMovies = movies.filter { movie in
                            movieIds.contains(movie.id)
                        }
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func refreshFavorites() {
        fetchFavoriteMovies()
    }
}
