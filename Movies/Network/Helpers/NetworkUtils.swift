//
//  HTTPMethod.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Swift.Error {
    case invalidURL
    case noData
}
