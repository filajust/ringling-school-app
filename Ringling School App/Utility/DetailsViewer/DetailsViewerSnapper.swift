//
//  DetailsViewerSnapper.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/6/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct DetailsViewerSnapper {
    enum SnapPosition {
        case TopSnapPosition
        case MiddleSnapPosition
        case BottomSnapPosition
        case OffScreenBottomSnapPosition
    }
    
    private let mediumSwipeSpeedMinimumVelocity : CGFloat = 350
    private let fastSwipeSpeedMinimumVelocity : CGFloat = 3500
    private let springAnimationDampingConstant : CGFloat = 0.45
    private let springAnimationInitialVelocityConstant : CGFloat = 8
    
    var topSnapPosition : CGFloat!
    var middleSnapPosition : CGFloat!
    var bottomSnapPosition : CGFloat!
    var offScreenBottomSnapPosition : CGFloat!
    
    init(topSnapPosition: CGFloat, middleSnapPosition: CGFloat, bottomSnapPosition: CGFloat, offScreenBottomSnapPosition: CGFloat) {
        self.topSnapPosition = topSnapPosition
        self.middleSnapPosition = middleSnapPosition
        self.bottomSnapPosition = bottomSnapPosition
        self.offScreenBottomSnapPosition = offScreenBottomSnapPosition
    }
    
    func snapPosition(forYPosition yPosition : CGFloat) -> CGFloat {
        var snapPosition : CGFloat = 0
        
        let diffFromTop = abs(yPosition - topSnapPosition)
        let diffFromMid = abs(yPosition - middleSnapPosition)
        let diffFromBottom = abs(yPosition - bottomSnapPosition)
        
        let minDiff = min(diffFromTop, diffFromMid, diffFromBottom)
        if minDiff == diffFromTop {
            snapPosition = topSnapPosition
        } else if minDiff == diffFromMid {
            snapPosition = middleSnapPosition
        } else {
            snapPosition = bottomSnapPosition
        }
        
        return snapPosition
    }
    
    func snapPosition(forYPosition yPosition: CGFloat, andSwipeVelocity velocity: CGPoint) -> CGFloat {
        var finalSnapPosition : CGFloat = 0
        if (velocity.y <= -mediumSwipeSpeedMinimumVelocity) { // swipe up
            if (yPosition > middleSnapPosition) {
                finalSnapPosition = middleSnapPosition
            } else {
                finalSnapPosition = topSnapPosition
            }
        } else if (velocity.y >= fastSwipeSpeedMinimumVelocity) { // really fast swipe down
            finalSnapPosition = bottomSnapPosition
        } else if (velocity.y >= mediumSwipeSpeedMinimumVelocity) { // swipe down
            if (yPosition < middleSnapPosition) {
                finalSnapPosition = middleSnapPosition
            } else {
                finalSnapPosition = bottomSnapPosition
            }
        } else { // slow release, so snap back to closest position
            finalSnapPosition = snapPosition(forYPosition: yPosition)
        }
        
        return finalSnapPosition
    }
    
    private func animate(view: UIView, toPosition position: CGFloat, withLayoutConstraint topPositionLayoutConstraint: NSLayoutConstraint, completion: @escaping () -> Void) {
        topPositionLayoutConstraint.constant = position
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: springAnimationDampingConstant, initialSpringVelocity: springAnimationInitialVelocityConstant, options: [.allowUserInteraction, .curveEaseIn], animations: {
            view.layoutIfNeeded()
        }) { finished in
            completion()
        }
    }
    
    func snapViewAndAnimate(_ view: UIView, withSwipeVelocity velocity: CGPoint, withLayoutConstraint topPositionLayoutConstraint: NSLayoutConstraint, completion: @escaping () -> Void) {
        let finalConstant = snapPosition(forYPosition: topPositionLayoutConstraint.constant, andSwipeVelocity: velocity)
        animate(view: view, toPosition: finalConstant, withLayoutConstraint: topPositionLayoutConstraint, completion: completion)
    }
    
    func snapViewAndAnimate(_ view: UIView, toSnapPosition snapPosition: SnapPosition, withLayoutConstraint topPositionLayoutConstraint: NSLayoutConstraint, completion: @escaping () -> Void) {
        var snapYPosition : CGFloat = 0
        switch snapPosition {
        case .TopSnapPosition:
            snapYPosition = topSnapPosition
        case .MiddleSnapPosition:
            snapYPosition = middleSnapPosition
        case .BottomSnapPosition:
            snapYPosition = bottomSnapPosition
        default:
            snapYPosition = offScreenBottomSnapPosition
        }
        
        animate(view: view, toPosition: snapYPosition, withLayoutConstraint: topPositionLayoutConstraint, completion: completion)
    }
}
