//
//  ForgotPasswordViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/22/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    var model: ForgotPasswordViewModel!
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToLoginFromForgotPassword", sender: self)
    }
    
    @IBAction func resetButtonPushed(_ sender: UIButton) {
        if validateEmailField(emailField: emailField) {
            model.sendResetPasswordEmail(email: emailField.text!)
            performSegue(withIdentifier: "unwindToLoginFromForgotPassword", sender: self)
        }
    }
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = ForgotPasswordViewModel()

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
}
