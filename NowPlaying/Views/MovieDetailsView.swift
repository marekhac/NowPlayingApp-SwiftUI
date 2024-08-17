//
//  MovieDetailsView.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import SwiftUI

struct MovieDetailsView: View {
    @State var movie: Movie
    @Environment(\.dismiss) var dismiss
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.vertical) {
                poster
                title
                releaseDate
                Divider()
                voteAverageSection
                Divider()
                movieOverview
            }
            .padding()
        }
        .onAppear {
            favoriteMoviesManager.loadFavorites()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
    }
    
    private var poster: some View {
        Group {
            if let posterPath = movie.posterPath {
                AsyncImage(url: NetworkManager.getPosterFullURL(for: posterPath)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var title: some View {
        Text(movie.title)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.leading)
    }
    
    private var releaseDate: some View {
        Text("Data wydania: \(movie.releaseDate)")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    
    private var voteAverageSection: some View {
        VStack(alignment: .leading, spacing: Spacing.voteAverage) {
            VoteAverageStarsView(rating: movie.voteAverage ?? 0.0)
            Text("Ocena: \(movie.voteAverage ?? 0, specifier: "%.1f")/10")
                .font(.headline)
        }
    }
    
    private var movieOverview: some View {
        Text(movie.overview)
            .font(.body)
            .padding(.top, Padding.top)
    }
    
    private var favoriteButton: some View {
        Button(action: {
            favoriteMoviesManager.toggleFavorite(movieID: movie.id)
        }) {
            Image(systemName: favoriteMoviesManager.favoriteMovieIDs.contains(movie.id) ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
    }
}

private extension MovieDetailsView {
    enum Spacing {
        static let vertical = 20.0
        static let voteAverage = 5.0
    }
    
    enum Padding {
        static let top = 10.0
    }
}
