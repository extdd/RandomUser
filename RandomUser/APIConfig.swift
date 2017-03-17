//
//  APIConfig.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

// MARK: - ENUMS

enum APIDataField: String {
    
    case login = "login", gender = "gender", name = "name", email = "email", phone = "phone", picture = "picture"
    
}

enum APIExtraParam: String {
    
    case noinfo = "noinfo"
    
}

// MARK: - INTERFACE

protocol APIConfig {
    
    var baseURL: String { get } // base URL without params
    var fullURL: String { get } // full URL with params
    var dataFormat: String { get } // response data format
    var seedId: String { get } // unique seed id
    var usersNationality: String { get } // nationality of users
    var resultsCount: Int { get } // max number of results
    var includingDataFields: [APIDataField] { get } // response data restrictions
    var extraParams: [APIExtraParam] { get }  // extra parameters
    
}

// MARK: - IMPLEMENTATION

struct APIConfigImpl: APIConfig {
    
    let seedId = "extdd2017"
    
}

// MARK: - UTILS

extension APIConfig {

    func getFullURL(for config: APIConfig) -> String {
        
        let components = NSURLComponents(string: config.baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "format", value: config.dataFormat),
            URLQueryItem(name: "seed", value: config.seedId),
            URLQueryItem(name: "results", value: String(config.resultsCount)),
            URLQueryItem(name: "nat", value: config.usersNationality),
            URLQueryItem(name: "inc", value: includingDataFields.flatMap{ $0.rawValue }.joined(separator: ","))
        ]
        
        for param in config.extraParams {
            components?.queryItems?.append(URLQueryItem(name: param.rawValue, value: nil))
        }
        
        return components?.url?.absoluteString ?? config.baseURL
        
    }
    
}
