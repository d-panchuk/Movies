//
//  UIView+Animation.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension UIView {
    
    static func animateTap(view: UIView, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { completed in
            UIView.animate(withDuration: 0.2, animations: {
                view.transform = CGAffineTransform.identity
            }, completion: { completed in
                completion?()
            })
        })
    }
    
    static func animateAppearence(view: UIView, dx: CGFloat = 0, dy: CGFloat = 0, dz: CGFloat = 0) {
        view.alpha = 0
        view.layer.transform = CATransform3DTranslate(CATransform3DIdentity, dx, dy, dz)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                view.alpha = 1
                view.layer.transform = CATransform3DIdentity
            }
        )
    }
    
}
