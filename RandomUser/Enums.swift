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
    
    var symbol: String {
        switch self {
        case .male:
            return "♂"
        case .female:
            return "♀"
        }
    }
    
    static let all: [Gender] = [.male, .female]
    static func from(string: String) -> Gender {
        var gender: Gender = .male
        self.all.forEach { if $0.rawValue == string.lowercased() { gender = $0 } }
        return gender
    }
    
}

// MARK: - SORTING MODE

enum SortingMode: String {
    
    case firstName = "firstName", lastName = "lastName"
    
    static let all: [SortingMode] = [.firstName, .lastName]
    static var allRaw: [String] {
        return self.all.map { $0.rawValue }
    }
    
}

// MARK: - DISPLAY MODE

enum DisplayMode {
    
    case show, edit, add
    
}

// MARK: - LABEL TYPE

enum LabelType {
    
    case date, title, detail, gender
    
}

// MARK: - NETWORK DATA ERROR

enum NetworkDataError: String, Error, CustomStringConvertible {
    
    case NoData, InvalidJSON, NoUsersData
    
    var description: String {
        return "\(type(of: self)) \(self.rawValue)"
    }
    
}
