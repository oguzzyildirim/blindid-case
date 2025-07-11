//
//  MoviePosterCard.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SDWebImageSwiftUI
import SwiftUI

struct MoviePosterCard: View {
    @EnvironmentObject var router: RouterManager
    let movie: Movie
    let rank: Int?

    @State private var imageLoaded = false
    @State private var cacheType: SDImageCacheType = .none

    init(movie: Movie, rank: Int? = nil) {
        self.movie = movie
        self.rank = rank
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if imageLoaded {
                if let posterURL = movie.posterURL {
                    WebImage(url: URL(string: posterURL)) { image in
                        image.resizable()
                    } placeholder: {
                        CustomPlaceHolder()
                    }
                    .onSuccess { _, _, type in
                        cacheType = type
                        if type == .none {
                            withAnimation(.easeIn(duration: 0.4)) {
                                imageLoaded = true
                            }
                        } else {
                            imageLoaded = true
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

            Text("\(movie.id ?? 0)")
                .font(.robotoMedium(size: 70))
                .foregroundColor(.appMain)
                .shadow(color: .blue.opacity(1), radius: 1, x: 1, y: 1)
                .padding(.bottom, -20)
                .padding(.leading, -18)
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
