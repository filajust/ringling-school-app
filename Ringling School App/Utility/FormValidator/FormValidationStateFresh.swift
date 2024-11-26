//
//  FormValidationStateFresh.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/22/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

class FormValidationStateFresh : FormValidationStateBase {
    
    private var stillFresh = true
    
    override func isValid() -> Bool {
        return false
    }
    
    override func showUIAsValid() -> Bool {
        return true
    }
    
    override func textWasSubmitted() {
        stillFresh = false
    }
    
    override func nextState(forIsValid isValid: Bool) -> FormValidationState {
        if (stillFresh) { // on any change transition to fresh valid or invald
            if (isValid) {
                return FormValidationStateFreshValid()
            } else {
                return FormValidationStateFreshInvalid()
            }
        } else {
            return super.nextState(forIsValid: isValid)
        }
    }
}
