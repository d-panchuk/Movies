//
//  ProductionCountry.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

public class ProductionCountry: NSObject, Codable, NSCoding {
    let isoCode: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case isoCode = "iso_3166_1"
        case name
    }
    
    public required init?(coder: NSCoder) {
        guard let isoCode = coder.decodeObject(forKey: "isoCode") as? String,
            let name = coder.decodeObject(forKey: "name") as? String
        else { return nil }
        
        self.isoCode = isoCode
        self.name = name
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(isoCode, forKey: "isoCode")
        coder.encode(name, forKey: "name")
    }
}
