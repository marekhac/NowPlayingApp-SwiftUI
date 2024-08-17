//
//  MovieResponse.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}

struct Movie: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
     
            id = try container.decode(Int.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            overview = try container.decode(String.self, forKey: .overview)
            posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
            voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
            voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
            
            let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: releaseDateString) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                releaseDate = dateFormatter.string(from: date)
            } else {
                releaseDate = releaseDateString
            }
        }
}
