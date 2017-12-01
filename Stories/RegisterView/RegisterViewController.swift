//
//  RegisterViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController, UITextFieldDelegate {

    var model: RegisterViewModel!
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var handlenameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToFirstViewFromRegister", sender: self)
    }
    
    @IBAction func signUpButtonPushed(_ sender: UIButton) {
        
        if validateEmailField(emailField: emailField) && validateHandlenameField(handlenameField: handlenameField) && validatePasswordField(passwordField: passwordField) {
            model.createUser(email: emailField.text!, handlename: handlenameField.text!, password: passwordField.text!)
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC!, animated: true, completion: nil)
        }
        return
    }
    
    override func loadView() {
        if let view = UINib(nibName: "RegisterViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model = RegisterViewModel()
        
        // Gradation setting for background color
        let topColor = UIColor(red:1.00, green:0.51, blue:0.02, alpha:1.0)//UIColor(red:0.07, green:0.13, blue:0.26, alpha:1)
        let bottomColor = UIColor(red:1.00, green:0.17, blue:0.00, alpha:1.0)//UIColor(red:0.54, green:0.74, blue:0.74, alpha:1)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailField {
            validateEmailField(emailField: textField)
        } else if textField == handlenameField {
            validateHandlenameField(handlenameField: textField)
        } else if textField == passwordField {
            validatePasswordField(passwordField: textField)
        }
        return true
    }
    
    @discardableResult func validateEmailField(emailField: UITextField) -> Bool {
        if let text = emailField.text {
            if let floatingLabelTextField = emailField as? SkyFloatingLabelTextField {
                if !model.isCorrectEmailFormat(text: text) {
                    floatingLabelTextField.errorMessage = "Email Format is Incorrect"
                    return false
                } else {
                    floatingLabelTextField.errorMessage = ""
                    return true
                }
            }
        }
        return false
    }
    
    @discardableResult func validateHandlenameField(handlenameField: UITextField) -> Bool {
        if let text = handlenameField.text {
            if let floatingLabelTextField = handlenameField as? SkyFloatingLabelTextField {
                if !model.isCorrectHandlenameFormat(text: text) {
                    floatingLabelTextField.errorMessage = "Handlename is too short"
                    return false
                } else {
                    floatingLabelTextField.errorMessage = ""
                    return true
                }
            }
        }
        return false
    }
    
    @discardableResult func validatePasswordField(passwordField: UITextField) -> Bool {
        if let text = passwordField.text {
            if let floatingLabelTextField = passwordField as? SkyFloatingLabelTextField {
                if !model.isCorrectPasswordFormat(text: text) {
                    floatingLabelTextField.errorMessage = "Password is too short"
                    return false
                } else {
                    floatingLabelTextField.errorMessage = ""
                    return true
                }
            }
        }
        return false
    }
}
