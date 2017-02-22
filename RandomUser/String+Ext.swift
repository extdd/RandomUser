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
    
    func checkFormat(for type: TextFormatType) -> Bool {
        
        switch type {
        case .email:
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(location: 0, length: self.characters.count)
            let result = detector?.firstMatch(in: self, options: .reportCompletion, range: range)
            return result?.url?.scheme == "mailto" && result?.range.length == self.characters.count
            
        default:
            return false
        }
        
    }
    
    func formatted(to type: TextFormatType) -> String? {
        
        switch type {
        case .phone:
            let phoneCharacters = NSMutableCharacterSet(charactersIn: "*+#")
            phoneCharacters.formUnion(with: NSCharacterSet.decimalDigits)
            let phone = self.components(separatedBy: phoneCharacters.inverted).joined()
            if phone.characters.count > 0 { return phone }
            else { return nil }
 
        default:
            return nil
        }
        
    }
    
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
