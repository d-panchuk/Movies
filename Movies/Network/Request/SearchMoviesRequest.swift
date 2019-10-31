//
//  SearchMoviesRequest.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct SearchMoviesRequest: RequestType {
    let keyword: String
    let page: Int
    
    var data: RequestData {
        return RequestData(
            endpoint: MovieDbEndpoint.search,
            method: .get,
            parameters: [
                "api_key" : Constants.Network.movieDbApiKey,
                "query": keyword.replacingOccurrences(of: " ", with: "+"),
                "page" : page.description
            ]
        )
    }
}
