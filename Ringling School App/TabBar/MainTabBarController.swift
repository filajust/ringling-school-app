//
//  MainTabBarController.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/28/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let castViewController = selectedViewController as? TabBarExiter {
             // store whether it can change first in case the exit transitoin affects this value
            let canTabChange = castViewController.canTabChange()
            castViewController.tabBarExitTransition()
            
            return canTabChange
        }
        
        return true
    }

}
