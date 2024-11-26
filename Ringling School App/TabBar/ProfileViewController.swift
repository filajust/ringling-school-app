//
//  ProfileViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/28/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class ProfileViewController: BaseTabBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func dismissed() {
        popupViewController = nil
    }
    
    @IBAction func signIn(_ sender: Any) {
        popupViewController = RinglingThemePopupViewController.showPopup(fromViewController: self, withState: .Fail, withTitle: "Oops!", withMessage: "Sign in not implemented yet.", andButtonText: "Dismiss", dismissAction: { self.dismissed() })
    }
}
