//
//  TabBarExiterProtocol.swift
//  Ringling School App
//
//  Created by JJ Fila on 5/30/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

protocol TabBarExiter {
    func tabBarExitTransition()
    func canTabChange() -> Bool
}
