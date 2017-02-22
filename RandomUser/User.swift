//
//  User.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import RealmSwift
import Decodable

// MARK: - BASE MODEL FOR USER & USER SNAPSHOT

class UserBase: Object {

    dynamic var gender = ""
    dynamic var username = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var email: String? = nil
    dynamic var phone: String? = nil
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    override var hashValue: Int {
        return
            gender.hashValue ^
            firstName.hashValue ^
            lastName.hashValue ^
            (email?.hashValue ?? "".hashValue) ^
            (phone?.hashValue ?? "".hashValue)
    }
    
}

func ==(lhs: UserBase, rhs: UserBase) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
    
}

// MARK: - USER

final class User: UserBase {
    
    dynamic var pictureURL: String? = nil
    dynamic var thumbnailURL: String? = nil
    
    var snapshots = List<UserSnapshot>()

    convenience init(gender: String, username: String, firstName: String, lastName: String, email: String? = nil, phone: String? = nil, pictureURL: String? = nil, thumbnailURL: String? = nil) {
        
        self.init()
        self.gender = gender
        self.username = username
        self.firstName = firstName.capitalized
        self.lastName = lastName.capitalized
        self.email = email
        self.phone = phone?.formatted(to: .phone)
        self.pictureURL = pictureURL
        self.thumbnailURL = thumbnailURL
        
    }
    
    override static func primaryKey() -> String? {
        
        return "username"
        
    }
    
}

// MARK: - DECODABLE

extension User: Decodable {
    
    static func decode(_ json: Any) throws -> User {
        
        return try User(
            gender: json => "gender",
            username: json => "login" => "username",
            firstName: json => "name" => "first",
            lastName: json => "name" => "last",
            email: json => "email",
            phone: json => "phone",
            pictureURL: json => "picture" => "large",
            thumbnailURL: json => "picture" => "thumbnail"
        )
        
    }
    
}
