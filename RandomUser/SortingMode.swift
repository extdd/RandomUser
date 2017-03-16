//
//  SortingMode.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.03.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

enum SortingMode: String {
    
    case firstName = "firstName", lastName = "lastName"
    
    static let all: [SortingMode] = [.firstName, .lastName]
    static var allRaw: [String] {
        return self.all.map { $0.rawValue }
    }
    
}
