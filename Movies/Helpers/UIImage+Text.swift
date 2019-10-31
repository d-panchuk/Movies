//
//  UIImage+Text.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func textEmbeded(image: UIImage, text: String, font: UIFont? = nil, isImageBeforeText: Bool = true) -> UIImage {
        let font = font ?? UIFont.systemFont(ofSize: 12)
        let expectedTextSize = (text as NSString).size(withAttributes: [.font: font])
        let width = expectedTextSize.width + image.size.width + 5
        let height = max(expectedTextSize.height, image.size.width)
        let size = CGSize(width: width, height: height)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2
            let textOrigin: CGFloat = isImageBeforeText ? image.size.width + 5 : 0
            let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
            text.draw(at: textPoint, withAttributes: [.font: font])
            
            let alignment: CGFloat = isImageBeforeText ? 0 : expectedTextSize.width + 5
            let rect = CGRect(x: alignment, y: (height - image.size.height) / 2,
                          width: image.size.width, height: image.size.height)
            image.draw(in: rect)
        }
    }
    
}
