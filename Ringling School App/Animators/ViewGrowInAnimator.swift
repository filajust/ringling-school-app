//
//  ViewGrowInAnimator.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/15/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct ViewGrowInAnimator {
    
    static internal func growInAnimationFor(view: UIView, forDuration duration: TimeInterval, afterDelay delay: TimeInterval, withOptions options: UIViewAnimationOptions, completion: @escaping ()->Void) {
        
        let originalSize = view.frame.size
        let originalPosition = view.frame.origin
        view.frame.size = CGSize(width:0, height:0)
        view.frame.origin = CGPoint(x: originalPosition.x + originalSize.width*0.5, y: originalPosition.y + originalSize.height*0.5)
        
        let animation : () -> Void = {
            view.frame.size = originalSize
            view.frame.origin = originalPosition
        }
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: options, animations: {
            animation()
        }, completion: { finished in
            completion()
        })
    }
    
    static internal func animateSpringOscillationOnLoop(viewToPercents viewAndPercent:(view: UIView, lowPercent: CGFloat), forDuration duration: TimeInterval, afterDelay delay: TimeInterval, withOptions options: UIViewAnimationOptions, completion: @escaping ()->Void) {
        //TODO: gropu duplicate code with func above

        assert(viewAndPercent.lowPercent >= 0 , "Percent must be greater than 0")
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [UIViewKeyframeAnimationOptions.repeat, UIViewKeyframeAnimationOptions.calculationModeCubic] , animations: {

            let originalSize = viewAndPercent.view.frame.size
            // animate to smaller size
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                let oldSize = viewAndPercent.view.frame.size
                let newSize = CGSize(width:originalSize.width * viewAndPercent.lowPercent,
                                     height:originalSize.height * viewAndPercent.lowPercent)
                viewAndPercent.view.frame.size = newSize
                let exisitingPosition = viewAndPercent.view.frame.origin
                let newPosition = CGPoint(x: exisitingPosition.x - (newSize.width-oldSize.width)*0.5,
                                          y: exisitingPosition.y - (newSize.height-oldSize.height)*0.5)
                viewAndPercent.view.frame.origin = newPosition
            })
            // animate to bigger size
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                let oldSize = viewAndPercent.view.frame.size
                let newSize = originalSize
                viewAndPercent.view.frame.size = newSize
                let exisitingPosition = viewAndPercent.view.frame.origin
                let newPosition = CGPoint(x: exisitingPosition.x - (newSize.width-oldSize.width)*0.5,
                                          y: exisitingPosition.y - (newSize.height-oldSize.height)*0.5)
                viewAndPercent.view.frame.origin = newPosition
            })
        }) { finished in
            completion()
        }
    }
}
