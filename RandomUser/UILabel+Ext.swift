//
//  UILabel+Ext.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 22.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    // quick creating custom label
    
    class func create(text: String? = nil, type: LabelType = .text) -> UILabel {
        
        let label = UILabel(frame: .zero)
        var font: UIFont
        var color: UIColor
        
        if text != nil { label.text = text }
        
        switch type {
        case .text:
            font = CustomFont.text
            color = CustomColor.text
            
        case .header:
            font = CustomFont.header
            color = CustomColor.text
            
        case .detail:
            font = CustomFont.detail
            color = CustomColor.text
            label.numberOfLines = 0
            
        case .date:
            font = CustomFont.date
            color = .white
   
        case .symbol:
            font = CustomFont.symbol
            color = .lightGray
            label.textAlignment = .center

        case .validationInfo:
            font = CustomFont.validationInfo
            color = CustomColor.defaultTint
            label.isHidden = true
        }
        
        label.font = font
        label.textColor = color
        label.sizeToFit()
        return label
            
    }
    
}
