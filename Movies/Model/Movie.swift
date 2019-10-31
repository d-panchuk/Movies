//
//  Movie.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    // basic
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]?
    let originalTitle: String
    let originalLanguage: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    // detailed
    let genres: [Genre]?
    let productionCountries: [ProductionCountry]?
    let runtime: Int?

}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
        case genres
        case productionCountries = "production_countries"
        case runtime
    }
}

extension Movie {
    
    var fullPosterPath: String? {
        guard let path = posterPath else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    var fullBackdropPath: String? {
        guard let path = backdropPath else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w780\(path)"
    }
    
}

extension Movie {
    enum Category: String, CaseIterable {
        case popular = "Popular"
        case upcoming = "Upcoming"
        case topRated = "Top Rated"
        case nowPlaying = "Now Playing"
        
        var displayableText: String {
            return self.rawValue
        }
        
        init?(index: Int) {
            guard index >= 0 && index < Category.allCases.count else { return nil }
            self = Category.allCases[index]
        }
    }
}

extension Movie {
    enum List: String, CaseIterable {
        case watched = "Watched"
        case favorite = "Favorite"
        case watchLater = "Watch Later"
    }
}

extension Movie.List {
    var displayableText: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .watched: return "eye"
        case .favorite: return "heart"
        case .watchLater: return "clock"
        }
    }
    
    var filledIconName: String {
        return iconName.appending(".fill")
    }
}

extension Movie {
    
    func setupMovieEntity(entity: MovieEntity) {
        entity.id = Int64(id)
        entity.adult = adult
        entity.backdropPath = backdropPath
        entity.genreIds = (genreIds != nil) ? genreIds : genres?.map { $0.id }
        entity.originalLanguage = originalLanguage
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity
        entity.posterPath = posterPath
        entity.productionCountries = productionCountries
        entity.releaseDate = releaseDate
        entity.runtime = Int16(runtime ?? Constants.CoreData.unknownRuntime)
        entity.title = title
        entity.video = video
        entity.voteAverage = voteAverage
        entity.voteCount = Int64(voteCount)
    }
    
}
