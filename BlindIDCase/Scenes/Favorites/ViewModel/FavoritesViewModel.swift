//
//  FavoritesViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Combine
import Foundation
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
         favoriteService: FavoriteServiceProtocol = FavoriteService())
    {
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
            favoriteMovies = []
            return
        }

        isLoading = true
        errorMessage = nil

        authService.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                guard let self = self else { return }

                if let movieIds = user.likedMovies, !movieIds.isEmpty {
                    self.movieService.fetchMovies()
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            self.isLoading = false

                            if case let .failure(error) = completion {
                                self.errorMessage = error.localizedDescription
                            }
                        } receiveValue: { movies in
                            self.favoriteMovies = movies.filter { movie in
                                if let movieId = movie.id {
                                    return movieIds.contains(movieId)
                                } else {
                                    return false
                                }
                            }
                        }
                        .store(in: &self.cancellables)

                } else {
                    self.isLoading = false
                    self.favoriteMovies = []
                    return
                }
            }
            .store(in: &cancellables)
    }

    func refreshFavorites() {
        fetchFavoriteMovies()
    }
}
