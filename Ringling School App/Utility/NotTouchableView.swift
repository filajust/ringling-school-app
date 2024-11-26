//
//  NotTouchableView.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/18/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

class NotTouchableView : UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if (hitView == self) {
            hitView = nil
        }
        
        return hitView
    }
}
