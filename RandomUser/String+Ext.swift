//
//  String+Ext.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 10.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//
//  Written for support generating unique usernames
//

import Foundation

extension String {
    
    // adding new number or incrementing the existing at the end of string
    
    mutating func addNumber() {
        
        var detectedNumber: Int?
        var newNumber: Int
        
        for i in 1 ..< self.characters.count {
            let suffix = String(self.characters.suffix(i))
            let number = Int(suffix)
            if number != nil {
                detectedNumber = number
            } else {
                break
            }
        }
        
        if detectedNumber == nil {
            // if number was not detected, setting new one
            newNumber = 1
        } else {
            // incrementing detected number
            newNumber = detectedNumber! + 1
            // removing current number from the string
            self = String(self.characters.dropLast(String(detectedNumber!).characters.count))
        }
        
        // adding new unique number
        self.append(String(newNumber))
        
    }
    
}
