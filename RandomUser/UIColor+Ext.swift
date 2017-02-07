//
//  UIColor+Ext.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 25.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, alpha: Float) {
        
        self.init(red:   CGFloat( (hex & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex & 0x00FF00) >> 8  ) / 255.0,
                  blue:  CGFloat( (hex & 0x0000FF) >> 0  ) / 255.0,
                  alpha: CGFloat( alpha ))
        
    }
    
    convenience init(hex: Int) {
        
        self.init(hex: hex, alpha: 1.0)
        
    }
    
}
