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
    
    class func create(text: String? = nil, type: LabelType = .text, align: NSTextAlignment = .left, lines: Int = 1) -> UILabel {
        
        let label = UILabel(frame: .zero)
        var font: UIFont
        var color: UIColor
        
        if text != nil {
            label.text = text
        }

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

        case .date:
            font = CustomFont.date
            color = .white
   
        case .symbol:
            font = CustomFont.symbol
            color = CustomColor.gray
            label.textAlignment = .center

        case .validationInfo:
            font = CustomFont.validationInfo
            color = CustomColor.red
            label.isHidden = true
        }
        
        label.font = font
        label.textColor = color
        label.textAlignment = align
        label.numberOfLines = lines
        label.sizeToFit()
        return label
            
    }
    
}
