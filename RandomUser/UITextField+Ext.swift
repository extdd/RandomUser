//
//  UITextField+Ext.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 22.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    // quick creating custom text field
    
    class func create(text: String? = nil, placeholder: String? = nil, capitalized: Bool? = false, keyboard: UIKeyboardType? = nil) -> UITextField {
        
        let field = UITextField(frame: .zero)
        if text != nil { field.text = text }
        if placeholder != nil { field.placeholder = placeholder }
        if capitalized == true { field.autocapitalizationType = .sentences }
        if keyboard != nil { field.keyboardType = keyboard! }
        
        field.textColor = CustomColor.text
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.sizeToFit()
        return field
        
    }
    
}
