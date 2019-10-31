//
//  Storyboarded.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(storyboardName: String = "Main") -> Self {
        let className = NSStringFromClass(self).components(separatedBy: ".")[1]
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
    
}
