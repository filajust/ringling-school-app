//
//  FormValidState.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/22/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

// State pattern implemented with this protocol.
//
// There are 5 states:
//    FRESH: No changes to form
//    FRESH VALID: changes to form but these changes have not been submitted but the content is valid
//    FRESH INVALID: changes to form but these changes have not been submitted and the content is invalid
//    VALID: form has been submitted and the content is valid
//    INVALID: form has been submitted and the content is not valid
//
// Finite state automata for these states:
//
//
//                          FRESH
//                            0 start
//                            |
//                            |
//                            | ---- submitted text ---.
//                            |                        |
//                            |                        |
//   FRESH VALID              v       FRESH INVALID    |
//   start 0 <---------- edit -----------> O           |
//         |                               |           |
//         |                               |           |
//     submitted text -------- -- submitted text <-----'
//                            |
//        ____________________v________________
//       /                                     \
//      v                                       v
//      O <---.                           .---> O
//    VALID    \___edited text __________/    INVALID
//
//
protocol FormValidationState {
    func isValid() -> Bool
    func showUIAsValid() -> Bool
    func textWasSubmitted()
    func nextState(forIsValid isValid: Bool) -> FormValidationState
}

class FormValidationStateBase : FormValidationState {
    func isValid() -> Bool {
        fatalError("Must be implemented in subclass")
    }
    
    func showUIAsValid() -> Bool {
        fatalError("Must be implemented in subclass")
    }
    
    func textWasSubmitted() {
        // default case performs no action here
    }
    
    func nextState(forIsValid isValid: Bool) -> FormValidationState {
        if (isValid) {
            return FormValidationStateValid()
        } else {
            return FormValidationStateInvalid()
        }
    }
}
