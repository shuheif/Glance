//
//  LoginViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    
    init() {}
    
    // Signs the user in
    func signIn(email: String, password: String) -> Bool {
        var success = false
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if user == nil || error != nil {
                success = false
                print("user nil")
                try! Auth.auth().signOut()
            } else {
                if user!.isEmailVerified {
                    print("email is verified")
                    success = true
                } else {
                    print("email isn't verified")
                    success = false
                }
            }
        })
        return success
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
    
    func isCorrectPasswordFormat(text: String) -> Bool {
        
        if text.isEmpty {
            return false
        }
        if text.count <= 5 {
            return false
        }
        return true
    }
    
}
