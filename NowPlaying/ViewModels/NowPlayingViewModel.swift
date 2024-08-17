//
//  NowPlayingViewModel.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import Foundation

class NowPlayingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var foundMovies: [Movie] = []
    @Published var query = ""
    
    private var networkManager = NetworkManager()
    private var currentPage  = 1
    private var totalPages = 1
    
    @MainActor
    func searchMovies() async {
        isLoading = true
        do {
            let movies = try await networkManager.searchMovies(query: query)
            if let movies {
                foundMovies = movies.results
                isLoading = false
            }
        } catch {
            isLoading = false
        }
    }
    
    @MainActor
    func getNowPlayingMovies(forPage page: Int) async {
        isLoading = true
        do {
            let movies = try await networkManager.getNowPlayingMovies(page: page)
            if let movies {
                if page == 1 {
                    foundMovies = movies.results
                } else {
                    foundMovies.append(contentsOf: movies.results)
                }
                currentPage = movies.page
                totalPages = movies.totalPages
                isLoading = false
            }
        } catch {
            isLoading = false
        }
    }
    
    @MainActor
    func loadMoreMovies() async {
        guard currentPage < totalPages && !isLoading else { return }
        await getNowPlayingMovies(forPage: currentPage + 1)
    }
}
