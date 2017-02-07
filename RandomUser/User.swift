//
//  User.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import RealmSwift
import Decodable

// MARK: - REALM OBJECT

final class User: Object {
    
    dynamic var gender = ""
    dynamic var username = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var email = ""
    dynamic var phone = ""
    dynamic var pictureURL:String? = nil
    dynamic var thumbnailURL:String? = nil
    
    var fullName: String {
        return "\(firstName.capitalized) \(lastName.capitalized)"
    }
    
    convenience init(gender:String, username:String, firstName:String, lastName:String, email:String, phone:String, pictureURL:String? = nil, thumbnailURL:String? = nil) {
        
        self.init()
        self.gender = gender
        self.username = username
        self.firstName = firstName.capitalized
        self.lastName = lastName.capitalized
        self.email = email
        self.phone = phone
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
