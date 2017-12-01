//
//  UIViewExtension.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/21/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
