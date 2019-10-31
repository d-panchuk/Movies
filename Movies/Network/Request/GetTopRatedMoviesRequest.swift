//
//  GetTopRatedMoviesRequest.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct GetTopRatedMoviesRequest: RequestType {
    let page: Int
    
    var data: RequestData {
        return RequestData(
            endpoint: MovieDbEndpoint.topRated,
            method: .get,
            parameters: [
                "api_key" : Constants.Network.movieDbApiKey,
                "page" : page.description
            ]
        )
    }
}
