//
//  HomeViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let movieService: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        fetchMovies()
    }

    func fetchMovies() {
        isLoading = true
        errorMessage = nil

        movieService.fetchMovies()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false

                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
