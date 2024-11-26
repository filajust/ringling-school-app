//
//  UIColor+Utilities.swift
//  Ringling School App
//
//  Created by JJ Fila on 4/18/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func darkerColor() -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}
        
        return UIColor(hue: h,
                       saturation: s,
                       brightness: b * 0.95,
                       alpha: a)
    }
}
