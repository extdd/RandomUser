//
//  UserSnapshot.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 15.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//
//  Snapshot of user data for the change history
//

import RealmSwift

// MARK: - USER SNAPSHOT

class UserSnapshot: UserBase {
    
    dynamic var timestamp = 0
    
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    convenience init(gender: String,
                     username: String,
                     firstName: String,
                     lastName: String,
                     email: String? = nil,
                     phone: String? = nil) {
        
        self.init()
        self.timestamp = Int(Date().timeIntervalSince1970)
        self.gender = gender
        self.username = username
        self.firstName = firstName.capitalized
        self.lastName = lastName.capitalized
        self.email = email
        self.phone = phone
        
    }
    
    override static func indexedProperties() -> [String] {
        
        return ["timestamp"]
        
    }
    
}
