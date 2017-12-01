//
//  RegisterViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RegisterViewModel {
    
    init() {}
    
    // Creates user for Firebase Authentication and Firebase database, and sends a verification email
    func createUser(email: String, handlename: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if user != nil {
                self.createNewUser(uid: user!.uid, handlename: handlename)
                user!.sendEmailVerification(completion: { (error) in
                    self.signOut()
                })
            }
        })
    }
    
    // Signs the user out
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("signOut")
        } catch let error as NSError {
            print ("Error signing out: %@", error)
        }
    }
    
    /*
     Creates New User with the new uid and user's handlename
     Called by Authentication.createUser
     */
    func createNewUser(uid: String, handlename: String) {
        print("createNewUser on database")
        let rootRef = Database.database().reference()
        let schoolRef = rootRef.child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id)
        schoolRef.child(TableNameStruct.usersTable).child(uid).setValue(["handlename": handlename, "points": 0, "posts": 0, "user_id": uid])
        let schoolsRef = rootRef.child("schools").child(TableNameStruct.beloit_id)
        schoolsRef.observeSingleEvent(of: .value, with: { snapshot in
            let school = School(snapshot: snapshot)
            let num_members = school.members
            schoolsRef.child("members").setValue(num_members + 1)
        })
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
    
    func isCorrectHandlenameFormat(text: String) -> Bool {
        
        if text.isEmpty {
            return false
        }
        if text.count <= 3 {
            return false
        }
        return true
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
    
    /*
     Only used manually
     */
    func createSchool(name: String, email: String) {
        print("createSchool")
        let school: [String: Any] = ["name": name,
                                     "email": email,
                                     "points": 0,
                                     "num_members": 0]
        let schoolRef = Database.database().reference().child(TableNameStruct.schoolsTable)
        schoolRef.childByAutoId().setValue(school)
    }
}
