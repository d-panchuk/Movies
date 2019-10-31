//
//  UIImageView+Load.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func setImage(from imagePath: String?, placeholder: UIImage? = UIImage(named: "PosterPlaceholder")) {
        guard let imagePath = imagePath, let url = URL(string: imagePath) else {
            self.image = placeholder
            return
        }
        
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.25))]
        )
    }
    
    func cancelImageLoading() {
        kf.cancelDownloadTask()
    }
    
}
