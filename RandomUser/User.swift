//
//  User.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import RealmSwift
import Decodable

final class User: Object {
    
    dynamic var gender = ""
    dynamic var username = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var pictureURL:String? = nil
    dynamic var thumbnailURL:String? = nil

    convenience init(gender:String, username:String, firstName:String, lastName:String, pictureURL:String?, thumbnailURL:String?) {
        
        self.init()
        self.gender = gender
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
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
            pictureURL: json => "picture" => "large",
            thumbnailURL: json => "picture" => "thumbnail"
        )
        
    }
    
}
