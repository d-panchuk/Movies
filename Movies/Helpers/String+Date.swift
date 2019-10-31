//
//  String+Date.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Format.movieDbDateFormat
        return dateFormatter.date(from: self)
    }
    
}
