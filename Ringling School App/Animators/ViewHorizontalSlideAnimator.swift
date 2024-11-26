//
//  ViewHorizontalSlideAnimator.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/13/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct ViewHoriztonalSlideAnimator {

    static internal func animate(viewsToPercents viewsAndPercents:[(view: UIView, xPercent: CGFloat)], forDuration duration: TimeInterval, withOptions options: UIViewAnimationOptions, completion: @escaping ()->Void) {
        
        var animations = [(() -> Void)]()
        for viewAndPercent in viewsAndPercents {
            assert(viewAndPercent.xPercent >= 0 && viewAndPercent.xPercent <= 1, "Percent must be between 0 and 1")
            
            if let superview = viewAndPercent.view.superview {
                let mostLeftXPossible = superview.bounds.origin.x - viewAndPercent.view.frame.size.width
                let mostRightXPossible = superview.bounds.origin.x + superview.bounds.size.width
                let xRange = mostRightXPossible - mostLeftXPossible
                
                let newXPosition = mostLeftXPossible + (xRange * viewAndPercent.xPercent)
                
                let animation : () -> Void = {
                    viewAndPercent.view.frame.origin.x = newXPosition
                }
                animations.append(animation)
            }
        }
        
        if !animations.isEmpty {
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                for animation in animations {
                    animation()
                }
            }, completion: { finished in
                completion()
            })
        }
    }
}
