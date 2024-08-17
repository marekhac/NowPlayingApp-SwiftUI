//
//  NetworkManager.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import Foundation

class NetworkManager {
    
    let apiKey = ""
    let baseURL = "https://api.themoviedb.org/3"
    static let posterImageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    func buildURLRequest(_ path: String, _ parameters: [String:Any]) -> URLRequest
    {
        let urlString = baseURL + path
        var urlComponents = URLComponents(string: urlString)!
        
        if !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems!.append(queryItem)
            }
        }
        
        let url = urlComponents.url!
        var request = NSMutableURLRequest(url: url) as URLRequest
        request.httpMethod = "GET"
        
        if let url = request.url {
           print("[NETWORK] Request to URL: \(url)")
        }
        
        return request as URLRequest
    }

    func get(request: URLRequest) async throws -> Data? {
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    static func getPosterFullURL(for posterPath: String) -> URL? {
        return URL(string: posterImageBaseURL + posterPath)
    }
}

