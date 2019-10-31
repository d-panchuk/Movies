//
//  MovieEntity+.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

extension MovieEntity {
    
    func toMovie() -> Movie? {
        guard
            let releaseDate = releaseDate,
            let originalTitle = originalTitle,
            let originalLanguage = originalLanguage,
            let title = title
        else { return nil }
        
        return Movie(
            id: Int(id),
            adult: adult,
            backdropPath: backdropPath,
            genreIds: genreIds,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: Int(voteCount),
            genres: nil,
            productionCountries: productionCountries,
            runtime: (runtime == Constants.CoreData.unknownRuntime) ? nil : Int(runtime))
    }
    
}
