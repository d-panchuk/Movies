//
//  GenreEntity+.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

extension GenreEntity {
    
    func toGenre() -> Genre? {
        guard let name = name else { return nil }
        return Genre(id: Int(id), name: name)
    }
    
}
