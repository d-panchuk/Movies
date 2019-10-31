//
//  GenresResponse.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

struct GenresResponse: Codable {
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
}
