//
//  Movie.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import Foundation

struct SearchResult: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page
        case results
    }
    
}

class Movie: Identifiable, Codable, Hashable {
    let adult: Bool
    let id: Int
    var backdropPath: String?
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    var posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var imageData: Data?
   
    
    private enum CodingKeys: String, CodingKey {
        case adult
        case id
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
