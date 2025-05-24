//
//  FavoriteService.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation
import Combine

protocol FavoriteServiceProtocol {
    func getFavoriteMovies() -> [Int]
    func toggleFavorite(movieId: Int) -> Bool
    func isFavorite(movieId: Int) -> Bool
}

final class FavoriteService: FavoriteServiceProtocol {
    private let favoritesKey = "favoriteMovies"
    
    private func saveToUserDefaults(favorites: [Int]) {
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func getFavoriteMovies() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    func toggleFavorite(movieId: Int) -> Bool {
        var favorites = getFavoriteMovies()
        
        if let index = favorites.firstIndex(of: movieId) {
            favorites.remove(at: index)
            saveToUserDefaults(favorites: favorites)
            return false
        } else {
            favorites.append(movieId)
            saveToUserDefaults(favorites: favorites)
            return true
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        let favorites = getFavoriteMovies()
        return favorites.contains(movieId)
    }
}
