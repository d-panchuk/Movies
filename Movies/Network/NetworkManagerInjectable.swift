//
//  NetworkManagerInjectable.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

protocol NetworkManagerInjectable {
    var networkManager: NetworkManager { get }
}

extension NetworkManagerInjectable {
    var networkManager: NetworkManager {
        NetworkManagerInjector.networkManager
    }
}

struct NetworkManagerInjector {
    static var networkManager = NetworkManager(dispatcher: URLSessionNetworkDispatcher())
}
