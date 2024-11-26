//
//  ContactUsViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/28/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: BaseTabBarViewController, UITextFieldDelegate, RinglingThemeTextViewDelegate {
    
    var formValidator = FormValidator()
    
    @IBOutlet weak var emailContentsTextView: RinglingThemeTextView!
    @IBOutlet weak var firstNameTextField: RinglingThemeTextField!
    @IBOutlet weak var lastNameTextField: RinglingThemeTextField!
    @IBOutlet weak var emailAddressTextField: RinglingThemeTextField!
    @IBOutlet weak var submitButton: RinglingThemeButton!
    @IBOutlet weak var admissionsEmailAddress: UITextView!
    
    // Intialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailContentsTextView.ringlingThemeTextViewDelegate = self
        submitButton.isEnabled = false
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: UIControlEvents.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: UIControlEvents.editingChanged)
        emailAddressTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: UIControlEvents.editingChanged)
        
        formValidator.add(form: emailContentsTextView)
        formValidator.add(form: firstNameTextField)
        formValidator.add(form: lastNameTextField)
        formValidator.add(form: emailAddressTextField)
        
        
        setupAdmissionsEmail()
    }
    
    private func setupAdmissionsEmail() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedStringKey : Any] = [
            .link : NSURL(string: "mailto:\(RinglingAppConstants.Miscellaneous.AdmissionsEmailAddress)")!,
            .font : UIFont.systemFont(ofSize: admissionsEmailAddress.font?.pointSize ?? 17),
            .paragraphStyle : paragraphStyle
        ]
        let attributedString = NSMutableAttributedString(string: admissionsEmailAddress.text)
        attributedString.setAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        
        let linkAttributes: [String : Any] =  [
            NSAttributedStringKey.foregroundColor.rawValue : RinglingAppConstants.Colors.PrimaryThemeColor.darkerColor()
        ]
        
        admissionsEmailAddress.linkTextAttributes = linkAttributes
        admissionsEmailAddress.attributedText = attributedString
        admissionsEmailAddress.isUserInteractionEnabled = true
        admissionsEmailAddress.isEditable = false
    }
    
    // Private
    
    private func clearForm() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailAddressTextField.text = ""
        emailContentsTextView.text = ""
        emailContentsTextView.updatePlaceholderState()
        FormValidationStateUpdater.resetValidationStates(forForms: &formValidator.forms)
    }
    
    private func createSmptSession() -> MCOSMTPSession {
        // using account: ringling.school.app@gmail.com, pw: RinglingIT2018
        let smptSession = MCOSMTPSession()
        smptSession.hostname = "smtp.gmail.com"
        smptSession.username = "ringling.school.app@gmail.com"
        smptSession.password = "RinglingIT2018"
        smptSession.port = 465
        smptSession.authType = MCOAuthType.saslPlain
        smptSession.connectionType = MCOConnectionType.TLS
        //        smptSession.connectionLogger = {(connectionID, type, data) in
        //            // can log connection updates here:
        //            if (data != nil) {
        //                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
        //                        NSLog("ConnectionLogger: \(string)")
        //                }
        //            }
        //        }
        
        return smptSession
    }
    
    private func createMessageBuilder(firstName: String, lastName: String, emailAddress: String, emailBody: String) -> MCOMessageBuilder {
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "JJ", mailbox: "justinfila@gmail.com")]
        builder.header.from = MCOAddress(displayName: firstName + " " + lastName, mailbox: emailAddress)
        builder.header.subject = "Inquiry via Ringling School App"
        builder.htmlBody = "<p>" + emailBody + "<br><br>------<br><br>Please respond to this inquiry via <a href=\"mailto:" + emailAddress + "\">" + emailAddress + "</a></p>"
        
        return builder
    }

    private func textSubmitted(_ sender : Any) {
        if let form = sender as? Form {
            FormValidationStateUpdater.textWasSubmitted(forForm: form)
        }
        textChanged(sender)
    }
    
    private func textChanged(_ sender : Any) {
        if var form = sender as? Form {
            FormValidationStateUpdater.updateValidationState(forForm: &form)
        
            if (formValidator.areAllFormsValid()) {
                submitButton.isEnabled = true
            } else {
                submitButton.isEnabled = false
            }
        }
    }
    
    
    @objc private func textFieldDidChange(_ sender : Any) { // this callback was set up in viewDidLoad
        textChanged(sender)
    }
    
    // UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = view.viewWithTag(nextTag) as UIResponder!
        
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textSubmitted(textField)
    }
    
    // RinglingThemeTextViewDelegate        
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textSubmitted(textView)
    }
    
    // Main Functionality
    
    @IBAction func callUs(_ sender: Any) {
        guard let formattedPhoneNumber = URL(string: "tel://" + RinglingAppConstants.Miscellaneous.RinglingPhoneNumber) else { return }
        UIApplication.shared.open(formattedPhoneNumber)
    }
    
    @IBAction func submitEmail(_ sender: Any) {
        let errorTitle = "Oops!"
        let successTitle = "Sent"
        let buttonText = "Dismiss"
        
        if (MFMailComposeViewController.canSendMail()) {
            self.popupViewController = RinglingThemePopupViewController.showPopup(fromViewController: self, withState: .Fail, withTitle: errorTitle, withMessage: "This device may not support this. Please contact us another way!", andButtonText: buttonText, dismissAction: {})
            return
        }
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let emailAddress = emailAddressTextField.text, let emailBody = emailContentsTextView.text else {
            
            self.popupViewController = RinglingThemePopupViewController.showPopup(fromViewController: self, withState: .Fail, withTitle: errorTitle, withMessage: "Please fill out all the fields.", andButtonText: buttonText, dismissAction: {})
            return
        }
        
        let smptSession = createSmptSession()
        let builder = createMessageBuilder(firstName: firstName, lastName: lastName, emailAddress: emailAddress, emailBody: emailBody)
        
        let rfc822Data = builder.data()
        let sendOperation = smptSession.sendOperation(with: rfc822Data)
        sendOperation?.start({ (error) in
            if (error != nil) {
                self.popupViewController = RinglingThemePopupViewController.showPopup(fromViewController: self, withState: .Fail, withTitle: errorTitle, withMessage: "There was an error. It could be your connection.", andButtonText: buttonText, dismissAction: {}) // do anything in error case?
            } else {
                self.popupViewController = RinglingThemePopupViewController.showPopup(fromViewController: self, withState: .Success, withTitle: successTitle, withMessage: "Thank you for contacting us!", andButtonText: buttonText, dismissAction: { self.clearForm() })
            }
        })
    }
}
