//
//  BlindIDCaseTests.swift
//  BlindIDCaseTests
//
//  Created by Oguz Yildirim on 21.05.2025.
//

@testable import BlindIDCase
import Combine
import XCTest

// MARK: - MockMovieService

class MockMovieService: MovieServiceProtocol {
    var fetchMoviesResult: Result<MoviesResponse, Error> = .success([])
    var fetchMovieDetailResult: Result<Movie, Error> = .success(Movie(id: 1, title: "Test", year: 2023, rating: 8.0, actors: [], category: "Action", posterURL: "", description: "Test description"))

    func fetchMovies() -> AnyPublisher<MoviesResponse, Error> {
        return fetchMoviesResult.publisher.eraseToAnyPublisher()
    }

    func fetchMovieDetail(id _: Int) -> AnyPublisher<Movie, Error> {
        return fetchMovieDetailResult.publisher.eraseToAnyPublisher()
    }
}

final class BlindIDCaseTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var mockMovieService: MockMovieService!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        mockMovieService = MockMovieService()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        homeViewModel = nil
        mockMovieService = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests

    func test_HomeViewModel_Init_SetsInitialStateCorrectly() {
        // Given
        mockMovieService.fetchMoviesResult = .success([])

        // When
        homeViewModel = HomeViewModel(movieService: mockMovieService)

        // Then
        XCTAssertTrue(homeViewModel.movies.isEmpty)
        XCTAssertNil(homeViewModel.errorMessage)
        // Note: isLoading might be true initially due to fetchMovies() call in init
    }

    // MARK: - Successful Fetch Tests

    func test_HomeViewModel_FetchMovies_ReturnsMoviesSuccessfully() {
        // Given
        let expectedMovies = [
            Movie(id: 1, title: "Movie 1", year: 2023, rating: 8.5, actors: ["Actor 1"], category: "Action", posterURL: "url1", description: "Description 1"),
            Movie(id: 2, title: "Movie 2", year: 2022, rating: 7.8, actors: ["Actor 2"], category: "Drama", posterURL: "url2", description: "Description 2"),
        ]
        mockMovieService.fetchMoviesResult = .success(expectedMovies)
        homeViewModel = HomeViewModel(movieService: mockMovieService)

        let expectation = XCTestExpectation(description: "Movies fetched successfully")

        // When
        homeViewModel.$movies
            .dropFirst() // Skip initial empty array
            .sink { movies in
                if !movies.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        homeViewModel.fetchMovies()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(homeViewModel.movies.count, 2)
        XCTAssertEqual(homeViewModel.movies.first?.title, "Movie 1")
        XCTAssertEqual(homeViewModel.movies.last?.title, "Movie 2")
        XCTAssertNil(homeViewModel.errorMessage)
    }

    // MARK: - Error Handling Tests

    func test_HomeViewModel_FetchMovies_HandlesNetworkErrorCorrectly() {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"])
        mockMovieService.fetchMoviesResult = .failure(expectedError)
        homeViewModel = HomeViewModel(movieService: mockMovieService)

        let expectation = XCTestExpectation(description: "Error handled correctly")

        // When
        homeViewModel.$errorMessage
            .compactMap { $0 }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        homeViewModel.fetchMovies()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(homeViewModel.errorMessage)
        XCTAssertEqual(homeViewModel.errorMessage, "Internal Server Error")
        XCTAssertFalse(homeViewModel.isLoading)
        XCTAssertTrue(homeViewModel.movies.isEmpty)
    }

    func test_HomeViewModel_FetchMovies_ClearsErrorMessageOnRetry() {
        // Given
        let error = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        mockMovieService.fetchMoviesResult = .failure(error)
        homeViewModel = HomeViewModel(movieService: mockMovieService)

        let errorExpectation = XCTestExpectation(description: "Error message set")
        let clearExpectation = XCTestExpectation(description: "Error message cleared")

        // When - First call with error
        homeViewModel.$errorMessage
            .compactMap { $0 }
            .sink { _ in
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)

        homeViewModel.fetchMovies()
        wait(for: [errorExpectation], timeout: 1.0)

        // Then - Verify error is set
        XCTAssertNotNil(homeViewModel.errorMessage)

        // When - Second call with success
        mockMovieService.fetchMoviesResult = .success([])

        homeViewModel.$errorMessage
            .sink { errorMessage in
                if errorMessage == nil {
                    clearExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        homeViewModel.fetchMovies()

        // Then
        wait(for: [clearExpectation], timeout: 1.0)
        XCTAssertNil(homeViewModel.errorMessage)
    }

    // MARK: - State Management Tests

    func test_HomeViewModel_FetchMovies_LoadingStateFalseAfterSuccess() {
        // Given
        let movies = [Movie(id: 1, title: "Test Movie", year: 2023, rating: 8.0, actors: [], category: "Action", posterURL: "", description: "Test")]
        mockMovieService.fetchMoviesResult = .success(movies)
        homeViewModel = HomeViewModel(movieService: mockMovieService)

        let expectation = XCTestExpectation(description: "Loading state false after success")

        // When
        homeViewModel.$isLoading
            .dropFirst() // Skip initial state
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        homeViewModel.fetchMovies()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(homeViewModel.isLoading)
        XCTAssertEqual(homeViewModel.movies.count, 1)
    }

    func test_HomeViewModel_FetchMovies_LoadingStateFalseAfterError() {
        // Given
        let error = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        mockMovieService.fetchMoviesResult = .failure(error)
        homeViewModel = HomeViewModel(movieService: mockMovieService)

        let expectation = XCTestExpectation(description: "Loading state false after error")

        // When
        homeViewModel.$isLoading
            .dropFirst() // Skip initial state
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        homeViewModel.fetchMovies()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(homeViewModel.isLoading)
        XCTAssertNotNil(homeViewModel.errorMessage)
    }
}
