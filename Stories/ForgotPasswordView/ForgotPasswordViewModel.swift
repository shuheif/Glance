//
//  ForgotPasswordViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import FirebaseAuth

class ForgotPasswordViewModel {
    
    init() {
        
    }
    
    /*
     Send Password Reset Email to the email
     */
    func sendResetPasswordEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
    // Validations
    
    func isCorrectEmailFormat(text: String) -> Bool {
        
        if text.isEmpty {
            return false
        }
        //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@beloit.edu"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}
