//
//  NowPlayingMoviesListView.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import SwiftUI

struct NowPlayingMoviesListView: View {
    @StateObject private var viewModel = NowPlayingViewModel()
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()

    var body: some View {
        NavigationView {
            VStack(spacing: Spacing.vertical) {
                searchMovieTextField
                movieList
            }
            .background(Color.tmdbBlue)
            .navigationTitle("Baza filmów")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.query.isEmpty && viewModel.foundMovies.isEmpty {
                    await viewModel.getNowPlayingMovies(forPage: 1)
                }
            }
        }
    }
    
    private var searchMovieTextField: some View {
        TextField("Znajdź film ...", text: $viewModel.query)
            .padding()
            .background(Color.tmdbGray)
            .cornerRadius(Radius.textField)
            .padding(.horizontal)
            .onChange(of: viewModel.query) { newValue in
                Task {
                    if newValue.isEmpty {
                        await viewModel.getNowPlayingMovies(forPage: 1)
                    } else {
                        await viewModel.searchMovies()
                    }
                }
            }
    }
    
    private var movieList: some View {
        List(viewModel.foundMovies, id: \.id) { movie in
            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                cell(for: movie)
            }
        }
    }
    
    private func cell(for movie: Movie) -> some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top) {
                poster(for: movie)
                description(of: movie)
            }
            favouriteStar(for: movie)
        }
        .onAppear {
            favoriteMoviesManager.loadFavorites()
            if movie == viewModel.foundMovies.last && viewModel.query.isEmpty {
                Task {
                    await viewModel.loadMoreMovies()
                }
            }
        }
    }
    
    private func poster(for movie: Movie) -> some View {
        Group {
            if let posterPath = movie.posterPath {
                AsyncImage(url: NetworkManager.getPosterFullURL(for: posterPath)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: Width.poster, height: Height.poster)
                .cornerRadius(Radius.poster)
            }
        }
    }
    
    private func description(of movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: Spacing.description) {
            Text(movie.title)
                .font(.headline)
            Text(movie.releaseDate)
                .font(.subheadline)
            Text(movie.overview)
                .font(.footnote)
                .lineLimit(4)
        }
    }
    
    private func favouriteStar(for movie: Movie) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: Width.circle, height: Height.circle)
                .shadow(radius: Radius.shadow)
            
            Image(systemName: favoriteMoviesManager.favoriteMovieIDs.contains(movie.id) ? "star.fill" : "star")
                .resizable()
                .foregroundColor(.yellow)
                .scaledToFit()
                .frame(width: Width.star, height: Height.star)
                .onTapGesture {
                    favoriteMoviesManager.toggleFavorite(movieID: movie.id)
                }
        }
        .padding(Padding.small)
    }
}

private extension NowPlayingMoviesListView {
    enum Spacing {
        static let vertical = 12.0
        static let description = 5.0
    }
    
    enum Radius {
        static let textField = 8.0
        static let poster = 8.0
        static let shadow = 1.0
    }
    
    enum Width {
        static var poster = 100.0
        static var circle = 30.0
        static var star = 15.0
    }
 
    enum Height {
        static var poster = 150.0
        static var circle = 30.0
        static var star = 15.0
    }
       
    enum Padding {
        static var small = 10.0
    }
}
