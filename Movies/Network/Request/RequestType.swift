//
//  RequestType.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

protocol RequestType {
    var data: RequestData { get }
}

struct RequestData {
    let endpoint: Endpoint
    let method: HTTPMethod
    let parameters: [String: Any]
    let headers: [String: String]
    
    init(
        endpoint: Endpoint,
        method: HTTPMethod,
        parameters: [String: Any] = [:],
        headers: [String: String] = [:]
    ) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}
