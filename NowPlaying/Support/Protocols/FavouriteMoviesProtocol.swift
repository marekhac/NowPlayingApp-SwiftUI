//
//  FavouriteMovies.swift
//  NowPlaying
//
//  Created by Marek Hac on 16/08/2024.
//

import Foundation

protocol FavouriteMoviesProtocol {
    var favoriteMovieIDs: Set<Int> { get set }
    
    func isFavourite(movie: Movie) -> Bool
    func toggleFavorite(movieID: Int)
    func loadFavorites()
    func saveFavorites()
}
