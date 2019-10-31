//
//  CategoryMoviesEntity+.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

extension CategoryMoviesEntity {
    
    var values: (Movie.Category?, Int, [Int]) {
        return (category, Int(page), movieIds ?? [])
    }
    
    var category: Movie.Category? {
        guard let categoryId = categoryId else { return nil }
        return Movie.Category(rawValue: categoryId)
    }
    
}
