//
//  NetworkManager+NowPlaying.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import Foundation

extension NetworkManager {
    func getNowPlayingMovies(page: Int = 1) async throws -> MovieResponse? {
           
        let path = "/movie/now_playing"
        let parameters = ["api_key": apiKey, 
                          "language" : "pl-PL",
                          "page" : String(page)]
        
        return try await fetchMovies(path: path, parameters: parameters)
    }
    
    func searchMovies(query: String) async throws -> MovieResponse? {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              !query.isEmpty else {
            return nil
        }
        
        let path = "/search/movie"
        let parameters = ["api_key": apiKey, "query" : query]
        
        return try await fetchMovies(path: path, parameters: parameters)
    }
    
    private func fetchMovies(path: String, parameters: [String: String]) async throws -> MovieResponse? {
        if parameters["api_key"]?.isEmpty ?? true {
            print("[⚠️] ERROR: No API KEY, please update \"apiKey\" property in NetworkManager")
            return nil
        }
        
        let request = buildURLRequest(path, parameters)
        guard let data = try await get(request: request) else { return nil }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(MovieResponse.self, from: data)
    }
}
