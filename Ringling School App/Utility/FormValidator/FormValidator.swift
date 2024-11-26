//
//  FormValidator.swift
//  Ringling School App
//
//  Created by JJ Fila on 5/24/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation

protocol Form {
    var validationState : FormValidationState { get set }
    
    func isValid() -> Bool
    func validationStateChanged()
}

struct FormValidationStateUpdater {
    static func update(formValidationState: FormValidationState, forForm form: inout Form) {
        form.validationState = formValidationState
        form.validationStateChanged()
    }
    
    static func updateValidationState(forForm form: inout Form) {
        FormValidationStateUpdater.update(formValidationState: form.validationState.nextState(forIsValid: form.isValid()), forForm: &form)
    }
    
    static func textWasSubmitted(forForm form: Form) {
        form.validationState.textWasSubmitted()
    }
    
    static func resetValidationStates(forForms forms: inout [Form]) {
        for i in 0..<forms.count {
            FormValidationStateUpdater.update(formValidationState: FormValidationStateFresh(), forForm: &forms[i])
        }
    }
}

struct FormValidator {
    
    var forms : [Form] = [Form]()
    
    mutating func add(form: Form) {
        forms.append(form)
    }
    
    func areAllFormsValid() -> Bool {
        for form in forms {
            if (!form.validationState.isValid()) {
                return false
            }
        }
        
        return true
    }
}


