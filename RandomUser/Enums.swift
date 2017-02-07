//
//  Enums.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 07.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

// MARK: - GENDER

enum Gender: String {
    
    case male = "male", female = "female"
    static let all: [Gender] = [.male, .female]
    
    static func fromString(string: String) -> Gender {
        
        var gender: Gender = .male
        self.all.forEach { if $0.rawValue == string.lowercased() { gender = $0 } }
        return gender
        
    }
    
}

// MARK: - SORTING MODE

enum SortingMode: String {
    
    case firstName = "firstName", lastName = "lastName"
    
}

// MARK: - DISPLAY MODE

enum DisplayMode {
    
    case show, edit
    
}

