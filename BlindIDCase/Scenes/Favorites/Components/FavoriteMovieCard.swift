//
//  FavoriteMovieCard.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 25.05.2025.
//

import SDWebImageSwiftUI
import SwiftUI

struct FavoriteMovieCard: View {
    @EnvironmentObject var router: RouterManager
    let movie: Movie

    @State private var imageLoaded = false
    @State private var cacheType: SDImageCacheType = .none

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if imageLoaded {
                if let posterURL = movie.posterURL {
                    WebImage(url: URL(string: posterURL)) { image in
                        image.resizable()
                    } placeholder: {
                        CustomPlaceHolder()
                    }
                    .onSuccess { _, _, type in
                        DispatchQueue.main.async {
                            self.cacheType = type
                            if type == .none {
                                withAnimation(.easeIn(duration: 0.4)) {
                                    self.imageLoaded = true
                                }
                            } else {
                                self.imageLoaded = true
                            }
                        }
                    }
                    .indicator(.activity)
                    .transition(.opacity)
                    .scaledToFit()
                    .frame(width: 140, height: 210)
                    .cornerRadius(16)
                } else {
                    CustomPlaceHolder()
                }
            } else {
                CustomPlaceHolder()
            }

            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.system(size: 16))
                .padding(8)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
                .padding(5)

            VStack(alignment: .leading) {
                Spacer()

                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 80)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title ?? "No Movie Title")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)

                        HStack {
                            Text(movie.year.map(String.init) ?? "Year not known")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)

                            Spacer()

                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 8))

                                Text(String(format: "%.1f", movie.rating ?? 0))
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(8)
                }
            }
        }
        .frame(width: 140, height: 210)
        .onAppear {
            imageLoaded = true
        }
        .onTapGesture {
            if let movieId = movie.id {
                router.show(.movieDetail(movieId: movieId), animated: true)
            }
        }
    }
}
