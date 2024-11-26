//
//  RinglingAwardsAnimator.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/15/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct RinglingAwardsAnimator {
    
    var awardImages = [UIImageView]()
    
    struct MeasuringUnits {
        static let xUnit : CGFloat = 1.0/4.0
        static let yUnit : CGFloat = 1.0/6.0
    }
    
    let imagePositionsDictionary = [ 0 : (xRatio: 1.0*MeasuringUnits.xUnit, yRatio: 1.0*MeasuringUnits.yUnit),
                                     1 : (xRatio: 3.0*MeasuringUnits.xUnit, yRatio: 1.0*MeasuringUnits.yUnit),
                                     2 : (xRatio: 2.0*MeasuringUnits.xUnit, yRatio: 2.0*MeasuringUnits.yUnit),
                                     3 : (xRatio: 1.0*MeasuringUnits.xUnit, yRatio: 3.0*MeasuringUnits.yUnit),
                                     4 : (xRatio: 3.0*MeasuringUnits.xUnit, yRatio: 3.0*MeasuringUnits.yUnit),
                                     5 : (xRatio: 2.0*MeasuringUnits.xUnit, yRatio: 4.0*MeasuringUnits.yUnit),
                                     6 : (xRatio: 1.0*MeasuringUnits.xUnit, yRatio: 5.0*MeasuringUnits.yUnit),
                                     7 : (xRatio: 3.0*MeasuringUnits.xUnit, yRatio: 5.0*MeasuringUnits.yUnit)]
    
    init() {
        setupAwardImages()
        
        assert(awardImages.count == 8, "must have 8 images")
        assert(imagePositionsDictionary.count == 8, "must have 8 positions")
    }
    
    private mutating func setupAwardImages() {
        let awardImageNames = RinglingAppConstants.Images.Awards.ImageNames
        
        for awardImageName in awardImageNames {
            if let image = UIImage(named: awardImageName) {
                let imageView = UIImageView(image: image)
                imageView.isOpaque = false
                imageView.backgroundColor = UIColor.clear
                
                awardImages.append(imageView)
            }
        }
    }
    
    // Functionality
    
    private func animate(imageView: UIImageView, insideView view: UIView, afterDelay delay: TimeInterval, completion: @escaping () -> Void) {
        view.insertSubview(imageView, at: 0)
        let imageViewAspectRatio = imageView.frame.size.width / imageView.frame.size.height
        imageView.frame.size.width = view.frame.size.width * 0.45 // set width to 1/4 of view width,  TODO: set to 1/4 of height or width
        imageView.frame.size.height = imageView.frame.size.width / imageViewAspectRatio
        
        let optionalIndex = awardImages.index(of: imageView)
        if let index = optionalIndex {
            let imagePosition = imagePositionFor(index: index, inRect: view.bounds)
            imageView.frame.origin = imagePosition
        }                        
        
        ViewGrowInAnimator.growInAnimationFor(view: imageView, forDuration: 1.0, afterDelay: delay, withOptions: .curveEaseInOut, completion: {
            let viewsAndPercentDuring : (UIView, CGFloat) = (imageView, 0.95)
            ViewGrowInAnimator.animateSpringOscillationOnLoop(viewToPercents: viewsAndPercentDuring, forDuration: 2.0, afterDelay: 0, withOptions: .curveEaseInOut, completion: {
                completion()
            })
        })
    }
    
    // assumes there are 8 slots
    private func imagePositionFor(index: Int, inRect rect: CGRect) -> CGPoint {
        assert(index >= 0 && index <= 7, "index must be between 0 and 7")
        
        var finalPosition = CGPoint()
        
        let imageView = awardImages[index]
        
        //TODO: multiply measuring units to set position at top?
        if let gridRelativePositions = imagePositionsDictionary[index] {
            let xGridPosition = rect.width * CGFloat(gridRelativePositions.xRatio)
            let yGridPosition = rect.height * CGFloat(gridRelativePositions.yRatio)
            
            let xPositionCenteredInGridPosition = xGridPosition - (imageView.frame.size.width*0.5)
            let yPositionCenteredInGridPosition = yGridPosition - (imageView.frame.size.height*0.5)
            
            finalPosition = CGPoint(x: xPositionCenteredInGridPosition, y: yPositionCenteredInGridPosition)
        }
        return finalPosition
    }
    
    // Exposed API
    
    internal func animate(insideParentView view: UIView) {
        // TODO: pass in delay value/store in constants?
        var delayOffset = 0.5
        var delay = 0.0
        var firstLoop = true
        for awardImage in awardImages {
            animate(imageView: awardImage, insideView: view, afterDelay: delay, completion: {}) // TODO: no need for completion?
            
            if (firstLoop == true)
            {
                delay = 0.5
                firstLoop = false
            }
            else if (delay >= 0.0) {
                delayOffset *= 0.85
            } else {
                delayOffset = 0.0
            }
            
            delay = delay + delayOffset
        }
    }
}
