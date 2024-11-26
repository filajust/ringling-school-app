//
//  DetailsDrawerView.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/5/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class DetailsDrawerView: UIView {
    
    var viewBackgroundPath : UIBezierPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isOpaque = false
        
        viewBackgroundPath = UIBezierPath(roundedRect:bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 15, height:  15))
        let maskLayer = CAShapeLayer()

        maskLayer.path = viewBackgroundPath.cgPath
        layer.mask = maskLayer
    }
    
    override func draw(_ rect: CGRect) {
        RinglingAppConstants.Colors.PrimaryThemeColor.setFill()
        viewBackgroundPath.fill()
        
        let gripperWidth : CGFloat = 60
        let gripperHeight : CGFloat = 5
        let gripperRect = CGRect(x: bounds.origin.x + bounds.size.width * 0.5 - gripperWidth * 0.5, y: 10, width: gripperWidth, height: gripperHeight)
        let gripperPath = UIBezierPath(roundedRect: gripperRect, cornerRadius: 5)

        UIColor.white.withAlphaComponent(0.7).setFill()
        gripperPath.fill()
    }
    
}
