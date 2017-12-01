//
//  UINavigationControllerExtension.swift
//  Stories
//
//  Created by Shuhei Fujita on 2015/03/10.
//  Copyright (c) 2015年 Shuhei Fujita. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setColor()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        super.viewWillAppear(true)
        setColor()
    }
    
    func setColor() {
        navigationBar.tintColor = UIColor.orange
        let font = UIFont(name: "Helvetica-Bold", size: 18)!
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font]
    }
}
