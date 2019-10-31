//
//  Reusable.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
