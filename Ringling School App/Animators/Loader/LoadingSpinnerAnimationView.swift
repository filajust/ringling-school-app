//
//  LoadingSpinnerAnimationView.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/13/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class LoadingSpinnerAnimationView: NotTouchableView, CAAnimationDelegate {

    var circleLoaderLayer : CircleSpinnerAnimationLayer!
    var leafLoaderLayer : LeafSpinnerAnimationLayer!
    var userStoppedAnimation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        isOpaque = false
        backgroundColor = UIColor.clear
        let sideLength = min(frame.width, frame.height)
        circleLoaderLayer = CircleSpinnerAnimationLayer(sideLength: sideLength)
        layer.addSublayer(circleLoaderLayer)
        
        let leafFrame = CGRect(x: bounds.midX - bounds.width + 2, y: -sideLength * 0.75, width: bounds.width, height: bounds.height * 0.5)
        leafLoaderLayer = LeafSpinnerAnimationLayer(pathFrame: leafFrame)
        
        layer.addSublayer(leafLoaderLayer)
    }
 
    private func setupInitialStateForAnimation() {
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
    }
    
    private func spinAnimation(withDuration duration: CFTimeInterval, repeatCount: Float, timingFunction: CAMediaTimingFunction) -> CAAnimationGroup {
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let roundedSpinCount = CGFloat((ceil(duration * 3 / 2))) // ceiling of spin count
        spinAnimation.toValue = roundedSpinCount * 2 * CGFloat.pi
        spinAnimation.duration = duration
        spinAnimation.timingFunction = timingFunction
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [spinAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = repeatCount
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.delegate = self
        
        return animationGroup
    }
    
    private func indefiniteLoadingAnimation() {
        circleLoaderLayer.indefiniteAnimation()
        leafLoaderLayer.indefiniteAnimation()
        
        setupInitialStateForAnimation()
        
        let animationGroup = spinAnimation(withDuration: 6.0, repeatCount: .infinity, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        layer.add(animationGroup, forKey: RinglingAppConstants.Animations.loadingSpinnerAnimation)
    }
    
    // CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // this method is called after the intro animation, so we need to check if it was called by us or the user
        if (userStoppedAnimation == false)
        {
            indefiniteLoadingAnimation()
        }
        userStoppedAnimation = false
    }
    
    // Main API
    
    func startLoadingAnimation() {
        guard (layer.animation(forKey: RinglingAppConstants.Animations.loadingSpinnerAnimationIntro) == nil) else {
            return
        }
        
        setupInitialStateForAnimation()
        
        circleLoaderLayer.animateIn()
        leafLoaderLayer.animateIn()
        
        let animationGroup = spinAnimation(withDuration: 3.5, repeatCount: 1.0, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        
        layer.add(animationGroup, forKey: RinglingAppConstants.Animations.loadingSpinnerAnimationIntro)
    }
    
    func stopLoadingAnimation(completion: @escaping () -> Void) {
        userStoppedAnimation = true
        
        circleLoaderLayer.animateOut()
        leafLoaderLayer.animateOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.layer.transform = self.layer.presentation()?.transform ?? CATransform3DMakeAffineTransform(CGAffineTransform.identity)
            self.layer.removeAllAnimations()
            completion()
        })
    }
}
