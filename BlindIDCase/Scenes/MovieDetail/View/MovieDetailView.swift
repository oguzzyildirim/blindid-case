//
//  MovieDetailView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: RouterManager
    @ObservedObject var viewModel: MovieDetailViewModel
    @State private var selectedTab: DetailTab = .about
    @AppStorage(StaticKeys.currentTab.key) private var currentTab: Int = TabBarItems.home.value

    enum DetailTab: CaseIterable {
        case about, cast

        var title: String {
            switch self {
            case .about: return "About Movie"
            case .cast: return "Cast"
            }
        }
    }

    init(movieId: Int) {
        viewModel = MovieDetailViewModel(movieId: movieId)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.appMain)
                .ignoresSafeArea()

            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if let movie = viewModel.movie {
                    movieContentView(movie: movie)
                } else {
                    emptyStateView
                }
            }
            MovieDetailNavigationBar(viewModel: viewModel)
                .environmentObject(router)
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showLoginAlert) {
            loginAlert
        }
    }
}

// MARK: - Private Views

private extension MovieDetailView {
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
    }

    func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text("Oops!")
                .font(.title)
                .foregroundColor(.white)

            Text(message)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Try Again") {
                viewModel.fetchMovieDetail()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.top, 60)
        .padding()
    }

    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            Text("No movie details available")
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(.top, 60)
    }

    func movieContentView(movie: Movie) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                posterImageSection(movie: movie)
                thumbnailSection(movie: movie)
                movieInfoBar(movie: movie)
                tabsSection(movie: movie)
            }
        }
    }

    func posterImageSection(movie: Movie) -> some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImageView(
                url: movie.safePosterURL,
                width: UIScreen.main.bounds.width,
                height: 250
            )

            if movie.hasValidRating {
                ratingBadge(rating: movie.safeRating)
            }
        }
    }

    func thumbnailSection(movie: Movie) -> some View {
        HStack(alignment: .top) {
            AsyncImageView(
                url: movie.safePosterURL,
                width: 95,
                height: 120,
                cornerRadius: 16
            )
            .padding(.leading)
            .offset(y: -30)

            VStack(alignment: .leading) {
                Text(movie.safeTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading, 8)

            Spacer()
        }
    }

    func movieInfoBar(movie: Movie) -> some View {
        HStack(spacing: 12) {
            InfoItem(
                icon: "calendar",
                text: movie.safeYearString
            )

            InfoDivider()

            InfoItem(
                icon: "clock",
                text: "-"
            )

            InfoDivider()

            InfoItem(
                icon: "ticket",
                text: movie.safeCategory
            )
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    func tabsSection(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            tabHeaders
            tabContent(movie: movie)
        }
    }

    var tabHeaders: some View {
        HStack(spacing: 24) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                TabHeaderView(
                    title: tab.title,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }

    func tabContent(movie: Movie) -> some View {
        Group {
            switch selectedTab {
            case .about:
                aboutContent(movie: movie)
            case .cast:
                castContent(movie: movie)
            }
        }
    }

    func aboutContent(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(movie.safeDescription)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }

    func castContent(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if movie.hasActors {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(movie.safeActors, id: \.self) { actor in
                        ActorRow(name: actor)
                    }
                }
            } else {
                EmptyActorsView()
            }
        }
        .padding()
    }

    var loginAlert: Alert {
        Alert(
            title: Text("Login Required"),
            message: Text("You need to be logged in to add this movie to favorites."),
            primaryButton: .default(Text("Login")) {
                router.pop(animated: true)
                currentTab = TabBarItems.profile.value
            },
            secondaryButton: .cancel()
        )
    }

    func ratingBadge(rating: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(String(format: "%.1f", rating))
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
        .padding([.bottom, .trailing], 16)
    }
}

// MARK: - Supporting Views

private struct AsyncImageView: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    init(url: URL?, width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 0) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Group {
            if let url = url {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade)
                    .scaledToFill()
            } else {
                PlaceholderImageView()
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
        .clipped()
    }
}

private struct PlaceholderImageView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)

            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)

                Text("No Image")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

private struct InfoItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(Color(UIColor.systemGray))
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(UIColor.systemGray))
        }
    }
}

private struct InfoDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 1, height: 16)
            .foregroundColor(Color(UIColor.darkGray))
    }
}

private struct TabHeaderView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)

            Rectangle()
                .frame(height: 4)
                .foregroundColor(isSelected ? Color.blue : Color.clear)
        }
        .onTapGesture(perform: action)
    }
}

private struct ActorRow: View {
    let name: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)

            Text(name)
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
}

private struct EmptyActorsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)

            Text("No cast information available")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Movie Extensions for Safe Optional Handling

extension Movie {
    var safeTitle: String {
        if let trimmed = title?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty {
            return trimmed
        }
        return "Unknown Title"
    }

    var safeDescription: String {
        if let trimmed = description?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty {
            return trimmed
        }
        return "No description available for this movie."
    }

    var safeCategory: String {
        if let trimmed = category?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty {
            return trimmed
        }
        return "Unknown"
    }

    var safeYearString: String {
        guard let year = year, year > 0 else { return "Unknown" }
        return "\(year)"
    }

    var safeRating: Double {
        rating ?? 0.0
    }

    var hasValidRating: Bool {
        guard let rating = rating else { return false }
        return rating > 0.0 && rating <= 10.0
    }

    var safePosterURL: URL? {
        guard let posterURL = posterURL,
              !posterURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }
        return URL(string: posterURL)
    }

    var safeActors: [String] {
        actors?.compactMap { actor in
            let trimmed = actor.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        } ?? []
    }

    var hasActors: Bool {
        !safeActors.isEmpty
    }

    var estimatedDuration: String {
        guard let id = id, id > 0 else { return "Unknown" }
        let duration = id * 8 // Using id*8 as mentioned in original code
        return "\(duration) Minutes"
    }

    var safeId: Int {
        id ?? 0
    }

    var hasValidId: Bool {
        guard let id = id else { return false }
        return id > 0
    }
}

// MARK: - Preview

#Preview {
    MovieDetailView(movieId: 17)
        .environmentObject(RouterManager.shared)
}
