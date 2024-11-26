//
//  FormValidationStateInvalid.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/22/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

class FormValidationStateInvalid : FormValidationStateBase {
    override func isValid() -> Bool {
        return false
    }
    
    override func showUIAsValid() -> Bool {
        return false
    }
}
