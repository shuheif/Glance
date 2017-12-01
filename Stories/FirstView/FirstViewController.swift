//
//  FirstViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func unwindToFirstView(segue: UIStoryboardSegue) {}
    
    @IBAction func signUpButtonPushed(_ sender: Any) {
        performSegue(withIdentifier: "FirstToRegisterSegue", sender: self)
    }
    @IBAction func loginButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToLoginSegue", sender: self)
    }
    
    override func loadView() {
        if let view = UINib(nibName: "FirstViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
}
