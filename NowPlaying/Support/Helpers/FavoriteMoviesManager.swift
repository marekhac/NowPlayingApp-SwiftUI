//
//  FavoriteMoviesManager.swift
//  NowPlaying
//
//  Created by Marek Hac on 16/08/2024.
//

import Foundation

class FavoriteMoviesManager: FavouriteMoviesProtocol, ObservableObject {
    private let favoritesKey = "favorite_movie_ids"
    
    @Published var favoriteMovieIDs: Set<Int> = [] {
        didSet {
            saveFavorites()
        }
    }

    func isFavourite(movie: Movie) -> Bool {
        favoriteMovieIDs.contains(movie.id)
    }
    
    func toggleFavorite(movieID: Int) {
        favoriteMovieIDs.formSymmetricDifference([movieID])
    }
    
    func loadFavorites() {
        if let favoritesArray = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favoriteMovieIDs = Set(favoritesArray)
        }
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteMovieIDs), forKey: favoritesKey)
    }
}
