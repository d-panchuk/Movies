//
//  Genre.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

extension Genre {
    
    func setupGenreEntity(_ entity: GenreEntity) {
        entity.id = Int64(id)
        entity.name = name
    }
    
}
