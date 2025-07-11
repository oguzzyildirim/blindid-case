//
//  HomeView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private func getRank(for movie: Movie) -> Int? {
        guard viewModel.movies.prefix(5).contains(where: { $0.id == movie.id }) else {
            return nil
        }

        if let index = viewModel.movies.firstIndex(where: { $0.id == movie.id }) {
            return index + 1
        }

        return nil
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appMain
                .ignoresSafeArea()

            VStack(spacing: 0) {
                homeNavigationBar

                contentView
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            Spacer()
        } else if let errorMessage = viewModel.errorMessage {
            Spacer()
            VStack {
                Text("Oops!")
                    .font(.title)
                    .foregroundColor(.white)

                Text(errorMessage)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Button("Try Again") {
                    viewModel.fetchMovies()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            Spacer()
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.movies) { movie in
                        MoviePosterCard(
                            movie: movie,
                            rank: getRank(for: movie)
                        )
                    }
                }
                .padding()
            }
        }
    }

    private var homeNavigationBar: some View {
        VStack(spacing: 0) {
            Color.appMain
                .frame(height: 0)
                .ignoresSafeArea(edges: .top)

            HStack {
                Text("Movies App")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(
                Color.appMain
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            )
        }
    }
}

#Preview {
    HomeView()
}
