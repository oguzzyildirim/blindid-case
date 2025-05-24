//
//  MovieDetailView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: RouterManager
    @ObservedObject var viewModel: MovieDetailViewModel
    @State private var selectedTab: DetailTab = .about
    @AppStorage(StaticKeys.currentTab.key) private var currentTab: Int = TabBarItems.home.value
    
    enum DetailTab {
        case about, cast
    }
    
    init(movieId: Int) {
        self.viewModel = MovieDetailViewModel(movieId: movieId)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            /// Background color
            Color(.appMain)
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
                        viewModel.fetchMovieDetail()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top, 60)
                .padding()
            } else if let movie = viewModel.movie {
                ScrollView {
                    VStack(spacing: 0) {
                        /// Poster Image
                        ZStack(alignment: .bottomTrailing) {
                            WebImage(url: URL(string: movie.posterURL))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade)
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(height: 250)
                                .clipped()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movie.rating))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.yellow.opacity(0.5))
                            .cornerRadius(8)
                            .padding([.bottom, .trailing], 16)
                        }
                        
                        // MARK: - Thumbnail
                        HStack(alignment: .top) {
                            WebImage(url: URL(string: movie.posterURL))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade)
                                .scaledToFill()
                                .frame(width: 95, height: 120)
                                .cornerRadius(16)
                                .padding(.leading)
                                .offset(y: -30)
                            
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 10)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                        }
                        
                        // MARK: - Movie Info Bar
                        HStack(spacing: 12) {
                            // Release Date
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(UIColor.systemGray))
                                Text("\(movie.year)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(UIColor.systemGray))
                            }
                            
                            // Divider
                            Rectangle()
                                .frame(width: 1, height: 16)
                                .foregroundColor(Color(UIColor.darkGray))
                            
                            // Duration
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(Color(UIColor.systemGray))
                                Text("\(movie.id * 8) Minutes") // Using id*8, since we don't have a duration field
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(UIColor.systemGray))
                            }
                            
                            // Divider
                            Rectangle()
                                .frame(width: 1, height: 16)
                                .foregroundColor(Color(UIColor.darkGray))
                            
                            // Genre
                            HStack(spacing: 4) {
                                Image(systemName: "ticket")
                                    .foregroundColor(Color(UIColor.systemGray))
                                Text(movie.category)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(UIColor.systemGray))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // MARK: - The Movie's Tabs
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 24) {
                                // About Movie Tab
                                VStack(spacing: 4) {
                                    Text("About Movie")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Rectangle()
                                        .frame(height: 4)
                                        .foregroundColor(selectedTab == .about ? Color.blue : Color.clear)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = .about
                                    }
                                }
                                
                                // Cast Tab
                                VStack(spacing: 4) {
                                    Text("Cast")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Rectangle()
                                        .frame(height: 4)
                                        .foregroundColor(selectedTab == .cast ? Color.blue : Color.clear)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = .cast
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                            
                            // MARK: - The Tabs Content
                            if selectedTab == .about {
                                // Movie Description
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(movie.description)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .lineSpacing(4)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding()
                            } else {
                                // Cast List
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        ForEach(movie.actors, id: \.self) { actor in
                                            HStack(spacing: 12) {
                                                Image(systemName: "person.circle.fill")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundColor(.gray)
                                                
                                                Text(actor)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            } else {
                Text("No movie details available")
                    .foregroundColor(.white)
                    .padding(.top, 60)
            }
            
            // MARK: - Navigation Bar
            VStack {
                HStack {
                    // Back Button
                    Button(action: {
                        router.pop(animated: true)
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(8)
                    }
                    
                    Spacer()
                    
                    // Title
                    if let movie = viewModel.movie {
                        Text(movie.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    } else {
                        Text("Movie Detail")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Favorite Button
                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite ? .red : .white)
                            .font(.system(size: 20))
                            .padding(8)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
                .background(Color(.appMain))
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showLoginAlert) {
            Alert(
                title: Text("Login Required"),
                message: Text("You need to be logged in to add this movie to favorites."),
                primaryButton: .default(Text("Login")) {
                    self.currentTab = TabBarItems.profile.value
                    router.popToRoot(animated: true)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MovieDetailView(movieId: 17)
        .environmentObject(RouterManager.shared as! RouterManager)
}
