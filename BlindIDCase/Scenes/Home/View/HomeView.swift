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
        GridItem(.flexible())
    ]
    
    private func getRank(for movie: Movie) -> Int? {
        guard viewModel.movies.prefix(5).contains(where: { $0.id == movie.id }) else {
            return nil
        }
        return viewModel.movies.firstIndex(where: { $0.id == movie.id })! + 1
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appMain
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if let errorMessage = viewModel.errorMessage {
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
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Movies App")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
