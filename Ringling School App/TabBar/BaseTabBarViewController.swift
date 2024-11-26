//
//  BaseTabBarViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/21/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class BaseTabBarViewController: ViewController, TabBarExiter {
    
    weak var popupViewController : RinglingThemePopupViewController? = nil
    
    // TabBarExiter
    
    func tabBarExitTransition() {
        popupViewController?.dismissPopupAndPerformAction()
    }
    
    func canTabChange() -> Bool {
        return popupViewController != nil ? false : true
    }

}
