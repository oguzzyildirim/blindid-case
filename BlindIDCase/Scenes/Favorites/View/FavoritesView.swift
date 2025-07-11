//
//  FavoritesView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    @EnvironmentObject var router: RouterManager

    @AppStorage(StaticKeys.loginStatus.key) private var isLoggedIn: Bool = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.appMain
                    .ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if !isLoggedIn {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)

                        Text(FavoritesTabStrings.loginRequired.value)
                            .font(.title)
                            .foregroundColor(.white)

                        Text(FavoritesTabStrings.loginRequiredDescription.value)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button(action: {
                            UserDefaults.standard.set(TabBarItems.profile.value, forKey: StaticKeys.currentTab.key)
                        }) {
                            Text(FavoritesTabStrings.loginRequiredButtonText.value)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Oops!")
                            .font(.title)
                            .foregroundColor(.white)

                        Text(errorMessage)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()

                        Button(LoginViewStrings.tryAgain.value) {
                            viewModel.fetchFavoriteMovies()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                } else if viewModel.favoriteMovies.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)

                        Text(FavoritesTabStrings.noFavorites.value)
                            .font(.title)
                            .foregroundColor(.white)

                        Text(FavoritesTabStrings.noFavoritesDescription.value)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button(action: {
                            // Set tab to home
                            UserDefaults.standard.set(TabBarItems.home.value, forKey: StaticKeys.currentTab.key)
                        }) {
                            Text(FavoritesTabStrings.discoverMovie.value)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.favoriteMovies) { movie in
                                FavoriteMovieCard(movie: movie)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.refreshFavorites()
                    }
                }
            }
            .navigationTitle("Favoriler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favori Filmlerim")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            viewModel.fetchFavoriteMovies()
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(RouterManager.shared)
}
