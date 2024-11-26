//
//  RinglingBannerAnimator.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/15/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct RinglingBannerAnimator {            
    
    func animate(imageView: UIImageView, andLabel label: UILabel, insideView view: UIView, completion: @escaping () -> Void) {
        let viewsAndPercentsIn : [(UIView, CGFloat)] = [(imageView, 0.7), (label, 0.75)]
        ViewHoriztonalSlideAnimator.animate(viewsToPercents:viewsAndPercentsIn, forDuration: 0.5, withOptions: .curveEaseInOut, completion: {
            
            let viewsAndPercentsDuring : [(UIView, CGFloat)] = [(imageView, 0.6), (label, 0.3)]
            ViewHoriztonalSlideAnimator.animate(viewsToPercents:viewsAndPercentsDuring, forDuration: 3.0, withOptions: .curveLinear, completion: {
                
                let viewsAndPercentsOut : [(UIView, CGFloat)] = [(imageView, 0.0), (label, 0.0)]
                ViewHoriztonalSlideAnimator.animate(viewsToPercents:viewsAndPercentsOut, forDuration: 0.5, withOptions: .curveEaseInOut, completion: {
                    
                    imageView.removeFromSuperview()
                    label.removeFromSuperview()
                    completion()
                })
            })
        })
    }
}
