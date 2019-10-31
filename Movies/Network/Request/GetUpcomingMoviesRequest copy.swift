//
//  GetUpcomingMovies.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct GetUpcomingMoviesRequest: RequestType {
    let page: Int
    
    var data: RequestData {
        return RequestData(
            endpoint: MovieDbEndpoint.upcoming,
            method: .get,
            parameters: [
                "api_key" : Constants.Network.movieDbApiKey,
                "page" : page.description
            ]
        )
    }
}
