//
//  CustomNavigationBar.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 26.05.2025.
//

import SwiftUI

struct BaseNavigationBar: View {
    @EnvironmentObject var router: RouterManager
    let navigationTitle: String
    
    var body: some View {
        VStack {
            ZStack {
                Color(.appMain)
                
                HStack {
                    Button(action: {
                        router.pop(animated: true)
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                
                Text(navigationTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(height: 60)
            
            Spacer()
        }
    }
}

struct MovieDetailNavigationBar: View {
    @EnvironmentObject var router: RouterManager
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Color(.appMain)
                
                HStack {
                    Button(action: {
                        router.pop(animated: true)
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite ? .red : .white)
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 16)
                
                Text(viewModel.movie?.safeTitle ?? "Movie Detail")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(height: 60)
            
            Spacer()
        }
    }
}
