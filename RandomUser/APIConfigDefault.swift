//
//  APIConfigDefault.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.03.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

// MARK: - DEFAULT IMPLEMENTATION

extension APIConfig {
    
    var baseURL: String {
        return "https://randomuser.me/api/"
    }
    var fullURL: String {
        return getFullURL(for: self)
    }
    var dataFormat: String {
        return "json"
    }
    var usersNationality: String {
        return "us"
    }
    var includingDataFields: [APIDataField] {
        return [.login, .gender, .name, .email, .phone, .picture]
    }
    var extraParams: [APIExtraParam] {
        return [.noinfo]
    }
    var resultsCount: Int {
        return 100
    }
    
}
