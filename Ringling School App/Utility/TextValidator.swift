//
//  TextValidator.swift
//  Ringling School App
//
//  Created by JJ Fila on 5/24/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct TextValidator {
    static func validate(text: String, forContentType contentType: UITextContentType?) -> Bool {
        var regexPattern = "(.+)" //default is to check for any character at all
        if let unwrappedContentType = contentType {
            switch unwrappedContentType
            {
            case UITextContentType.emailAddress:
                regexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
            case UITextContentType.telephoneNumber:
                regexPattern = "[0-9]{10,14}" // Phone Number, 10-14 digits
            default:
                break
            }
        }
        
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        let match = regex?.firstMatch(in: text, options: [], range: NSRange(location:0, length: text.count))
        
        if let unwrappedMatch = match {
            return unwrappedMatch.range.length >= 1
        }
        return false
    }
}
