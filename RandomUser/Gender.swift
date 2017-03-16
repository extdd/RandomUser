//
//  Gender.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.03.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

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
        self.all.forEach {
            if $0.rawValue == string.lowercased() {
                gender = $0
            }
        }
        return gender
        
    }
    
}
