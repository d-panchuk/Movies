//
//  GetMovieRequest.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct GetMovieRequest: RequestType {
    let id: Int
    
    var data: RequestData {
        return RequestData(
            endpoint: MovieDbEndpoint.movie(id: id),
            method: .get,
            parameters: [
                "api_key" : Constants.Network.movieDbApiKey
            ]
        )
    }
}
