//
//  CircleSpinnerAnimationLayer.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/13/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class CircleSpinnerAnimationLayer: CAShapeLayer {

    var circlePath : UIBezierPath!
    var lineWidthMax : CGFloat!
    
    init(sideLength: CGFloat) {
        super.init()
        
        frame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        bounds = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        
        strokeColor = RinglingAppConstants.Colors.AppOrangeColor.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidthMax = sideLength
        lineWidth = lineWidthMax
        lineCap = "round"
        
        circlePath = UIBezierPath(ovalIn: frame)
        path = circlePath.cgPath
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStateBeforeAnimation() {
        strokeEnd = 1.0
        strokeStart = 0.0
        transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
        lineWidth = lineWidthMax
    }
    
    func animateOut() {
        removeAllAnimations()
        strokeEnd = presentation()?.strokeEnd ?? 1.0
        strokeStart = presentation()?.strokeStart ?? 0.0
        transform = presentation()?.transform ?? CATransform3DMakeAffineTransform(CGAffineTransform.identity)
        lineWidth = 0
    }

    func animateIn() {
        guard (animation(forKey: RinglingAppConstants.Animations.loadingSpinnerAnimationIntro) == nil) else {
            return
        }

        setupStateBeforeAnimation()
        
        let tracePathAnimationStrokeEnd1 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd1.fromValue = 0.4
        tracePathAnimationStrokeEnd1.toValue = 0.7
        tracePathAnimationStrokeEnd1.duration = 1.0
        tracePathAnimationStrokeEnd1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        tracePathAnimationStrokeEnd1.fillMode = kCAFillModeBoth
        
        let tracePathAnimationStrokeEnd2 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd2.fromValue = 0.7
        tracePathAnimationStrokeEnd2.toValue = 1.0
        tracePathAnimationStrokeEnd2.duration = 0.5
        tracePathAnimationStrokeEnd2.beginTime = tracePathAnimationStrokeEnd1.beginTime + tracePathAnimationStrokeEnd1.duration
        tracePathAnimationStrokeEnd2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        tracePathAnimationStrokeEnd2.fillMode = kCAFillModeBoth
        
        let tracePathAnimationStrokeStart = CABasicAnimation(keyPath: "strokeStart")
        tracePathAnimationStrokeStart.fromValue = 0.4
        tracePathAnimationStrokeStart.toValue = 0.0
        tracePathAnimationStrokeStart.duration = 1.0
        tracePathAnimationStrokeStart.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        tracePathAnimationStrokeStart.fillMode = kCAFillModeBoth
        
        
        let increaseLineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        increaseLineWidthAnimation.fromValue = 0.0
        increaseLineWidthAnimation.toValue = lineWidthMax
        increaseLineWidthAnimation.duration = 1.5
        increaseLineWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        increaseLineWidthAnimation.fillMode = kCAFillModeBoth
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [tracePathAnimationStrokeEnd1, tracePathAnimationStrokeEnd2, tracePathAnimationStrokeStart, increaseLineWidthAnimation]
        animationGroup.duration = 3.5
        animationGroup.repeatCount = 1
        animationGroup.fillMode = kCAFillModeBoth
        
        add(animationGroup, forKey: RinglingAppConstants.Animations.loadingSpinnerAnimationIntro)
    }
    
    func indefiniteAnimation() {
        
        guard (animation(forKey: RinglingAppConstants.Animations.loadingSpinnerAnimation) == nil) else {
            return
        }
        
        setupStateBeforeAnimation()
        
        let tracePathAnimationStrokeEnd1 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd1.fromValue = 1.0
        tracePathAnimationStrokeEnd1.toValue = 0.9
        tracePathAnimationStrokeEnd1.duration = 0.5
        tracePathAnimationStrokeEnd1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let tracePathAnimationStrokeEnd2 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd2.fromValue = 0.9
        tracePathAnimationStrokeEnd2.toValue = 0.7
        tracePathAnimationStrokeEnd2.duration = 1.0
        tracePathAnimationStrokeEnd2.beginTime = tracePathAnimationStrokeEnd1.beginTime + tracePathAnimationStrokeEnd1.duration
        tracePathAnimationStrokeEnd2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let tracePathAnimationStrokeEnd3 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd3.fromValue = 0.7
        tracePathAnimationStrokeEnd3.toValue = 0.4
        tracePathAnimationStrokeEnd3.duration = 1.0
        tracePathAnimationStrokeEnd3.beginTime = tracePathAnimationStrokeEnd2.beginTime + tracePathAnimationStrokeEnd2.duration
        tracePathAnimationStrokeEnd3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let tracePathAnimationStrokeEnd4 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd4.fromValue = 0.4
        tracePathAnimationStrokeEnd4.toValue = 0.7
        tracePathAnimationStrokeEnd4.duration = 1.0
        tracePathAnimationStrokeEnd4.beginTime = tracePathAnimationStrokeEnd3.beginTime + tracePathAnimationStrokeEnd3.duration
        tracePathAnimationStrokeEnd4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let tracePathAnimationStrokeEnd5 = CABasicAnimation(keyPath: "strokeEnd")
        tracePathAnimationStrokeEnd5.fromValue = 0.7
        tracePathAnimationStrokeEnd5.toValue = 1.0
        tracePathAnimationStrokeEnd5.duration = 0.5
        tracePathAnimationStrokeEnd5.beginTime = tracePathAnimationStrokeEnd4.beginTime + tracePathAnimationStrokeEnd4.duration
        tracePathAnimationStrokeEnd5.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        
        let tracePathAnimationStrokeStart2 = CABasicAnimation(keyPath: "strokeStart")
        tracePathAnimationStrokeStart2.fromValue = 0.0
        tracePathAnimationStrokeStart2.toValue = 0.6
        tracePathAnimationStrokeStart2.duration = 1.0
        tracePathAnimationStrokeStart2.beginTime = tracePathAnimationStrokeEnd1.beginTime + tracePathAnimationStrokeEnd1.duration
        tracePathAnimationStrokeStart2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let tracePathAnimationStrokeStart3 = CABasicAnimation(keyPath: "strokeStart")
        tracePathAnimationStrokeStart3.fromValue = 0.6
        tracePathAnimationStrokeStart3.toValue = 0.4
        tracePathAnimationStrokeStart3.duration = 1.0
        tracePathAnimationStrokeStart3.beginTime = tracePathAnimationStrokeEnd2.beginTime + tracePathAnimationStrokeEnd2.duration
        tracePathAnimationStrokeStart3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let tracePathAnimationStrokeStart4 = CABasicAnimation(keyPath: "strokeStart")
        tracePathAnimationStrokeStart4.fromValue = 0.4
        tracePathAnimationStrokeStart4.toValue = 0.0
        tracePathAnimationStrokeStart4.duration = 1.0
        tracePathAnimationStrokeStart4.beginTime = tracePathAnimationStrokeEnd3.beginTime + tracePathAnimationStrokeEnd3.duration
        tracePathAnimationStrokeStart4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        let decreaseLineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        decreaseLineWidthAnimation.toValue = 0.0
        decreaseLineWidthAnimation.duration = 2.0
        decreaseLineWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let increaseLineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        increaseLineWidthAnimation.fromValue = 0.0
        increaseLineWidthAnimation.toValue = lineWidthMax
        increaseLineWidthAnimation.beginTime = decreaseLineWidthAnimation.beginTime + decreaseLineWidthAnimation.duration
        increaseLineWidthAnimation.duration = 2.0
        increaseLineWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        increaseLineWidthAnimation.fillMode = kCAFillModeForwards
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [tracePathAnimationStrokeEnd1, tracePathAnimationStrokeEnd2, tracePathAnimationStrokeStart2, tracePathAnimationStrokeEnd3, tracePathAnimationStrokeStart3, tracePathAnimationStrokeEnd4, tracePathAnimationStrokeStart4, tracePathAnimationStrokeEnd5, decreaseLineWidthAnimation, increaseLineWidthAnimation]
        animationGroup.duration = 6.0
        animationGroup.repeatCount = .infinity
        animationGroup.fillMode = kCAFillModeForwards
        
        add(animationGroup, forKey: RinglingAppConstants.Animations.loadingSpinnerAnimation)
    }
}
