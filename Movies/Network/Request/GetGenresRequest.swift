//
//  GetGenresRequest.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct GetGenresRequest: RequestType {
    var data: RequestData {
        return RequestData(
            endpoint: MovieDbEndpoint.genres,
            method: .get,
            parameters: [
                "api_key" : Constants.Network.movieDbApiKey
            ]
        )
    }
}
