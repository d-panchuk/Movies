//
//  MovieCellViewModel.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct MovieCellViewModel {
    
    var genresCountToDisplay = 2
    private var model: Movie
    
    var title: String {
        return model.title
    }
    
    var genres: String {
        if let genresList = model.genres {
            return makeGenresString(from: genresList)
        } else {
            return makeGenresString(from: model.genreIds ?? [])
        }
    }
    
    var releaseYear: String {
        return makeReleaseYearString(from: model.releaseDate)
    }
    
    var rating: String {
        let ratingString = model.voteAverage > 0 ? "\(model.voteAverage)" : Constants.Format.dash
        return "\(ratingString)"
    }
    
    var poster: String? {
        return model.fullPosterPath
    }
    
    init(model: Movie) {
        self.model = model
    }
    
    private func makeGenresString(from genres: [Genre]) -> String {
        let genreNames = genres.map { $0.name }
        return genreNames.prefix(genresCountToDisplay).joined(separator: Constants.Format.commaSeparator)
    }
    
    private func makeGenresString(from genreIds: [Int]) -> String {
        let genreEntities = CoreDataManager.shared.getAllGenreEntities()
        let genreNames = genreIds.compactMap { id in
            genreEntities.first(where: { $0.id == id })?.name
        }
        return genreNames.prefix(genresCountToDisplay).joined(separator: Constants.Format.commaSeparator)
    }
    
    private func makeReleaseYearString(from stringDate: String) -> String {
        guard let date = stringDate.toDate() else { return "" }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
    
}
