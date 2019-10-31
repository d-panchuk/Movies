//
//  Constants.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Network {
        static let movieDbBasePath = "https://api.themoviedb.org/3/"
        static let movieDbApiKey = "2fc4c12ff8801baa2825593c57da1558"
    }
    
    struct Format {
        static let dash = "–"
        static let bulletSeparator = " • "
        static let commaSeparator = ", "
        static let movieDbDateFormat = "yyyy-MM-dd"
    }
    
    struct Defaults {
        static let lastSearchesKey = "Last Searches"
    }
    
    struct CoreData {
        static let unknownRuntime = -1
    }
    
}
