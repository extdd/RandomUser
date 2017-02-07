//
//  NSObject+Ext.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 06.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
}
