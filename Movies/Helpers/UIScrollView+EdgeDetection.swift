//
//  UIScrollView+EdgeDetection.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func isNearRightEdge(edgeOffset: CGFloat = 20) -> Bool {
        return self.contentOffset.x + self.frame.size.width + edgeOffset > self.contentSize.width
    }
    
    func isNearBottomEdge(edgeOffset: CGFloat = 20) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
    
}
