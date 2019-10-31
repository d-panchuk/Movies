//
//  MovieApi.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

protocol Endpoint {
    var path: String { get }
}

enum MovieDbEndpoint {
    case movie(id: Int)
    case popular
    case upcoming
    case topRated
    case nowPlaying
    case genres
    case search
}

extension MovieDbEndpoint: Endpoint {
    var basePath: String {
        return Constants.Network.movieDbBasePath
    }
    
    var path: String {
        switch self {
        case let .movie(id):
            return basePath + "movie/\(id)"
        case .popular:
            return basePath + "movie/popular"
        case .upcoming:
            return basePath + "movie/upcoming"
        case .topRated:
            return basePath + "movie/top_rated"
        case .nowPlaying:
            return basePath + "movie/now_playing"
        case .genres:
            return basePath + "genre/movie/list"
        case .search:
            return basePath + "search/movie"
        }
    }
}
