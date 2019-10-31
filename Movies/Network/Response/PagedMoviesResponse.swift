//
//  PagedMoviesResponse.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

struct PagedMoviesResponse: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case page = "page"
        case totalPages = "total_pages"
    }
}
