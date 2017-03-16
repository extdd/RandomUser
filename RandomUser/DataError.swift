//
//  DataError.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.03.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

enum DataError: String, Error, CustomStringConvertible {
    
    case NoData, InvalidJSON, NoUsersData
    
    var description: String {
        return "\(type(of: self)) \(self.rawValue)"
    }
    
}
