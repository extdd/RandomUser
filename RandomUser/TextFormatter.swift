//
//  TextFormatter.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 26.03.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

enum TextFormatType {
    
    case email, phone
    
}

struct TextFormatter {
    
    // formatting
    
    static func format(_ string: String?, to type: TextFormatType) -> String? {
        
        switch type {
        case .phone:
            let phoneCharacters = NSMutableCharacterSet(charactersIn: "*+#")
            phoneCharacters.formUnion(with: NSCharacterSet.decimalDigits)
            if let phone = string?.components(separatedBy: phoneCharacters.inverted).joined(), phone.characters.count > 0 {
                return phone
            } else {
                return nil
            }
            
        default:
            return nil
        }
        
    }
    
    // checking format
    
    static func checkFormat(of string: String, for type: TextFormatType) -> Bool {
        
        switch type {
        case .email:
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(location: 0, length: string.characters.count)
            let result = detector?.firstMatch(in: string, options: .reportCompletion, range: range)
            return result?.url?.scheme == "mailto" && result?.range.length == string.characters.count
            
        default:
            return false
        }
        
    }
    
    // appending new number to the string or incrementing existing one
    
    static func appendNumber(to string: inout String) {
        
        var detectedNumber: Int?
        var newNumber: Int
        
        for i in 1 ..< string.characters.count {
            let suffix = String(string.characters.suffix(i))
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
            string = String(string.characters.dropLast(String(detectedNumber!).characters.count))
        }
        
        // appending new unique number
        string.append(String(newNumber))
        
    }
    
}
