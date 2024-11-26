//
//  FormValidationStateValid.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/22/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

class FormValidationStateValid : FormValidationStateBase {
    override func isValid() -> Bool {
        return true
    }
    
    override func showUIAsValid() -> Bool {
        return true
    }
}
