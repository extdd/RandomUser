//
//  APIConfig.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

// MARK: - INTERFACE

protocol APIConfig {
    
    var url: String { get }
    var format: String { get }
    var seed: String { get }
    var includeOnly: String { get }
    var nationality: String { get }
    var results: Int { get }
    var urlWithParams: String { get }
    
}
// MARK: - IMPLEMENTATION

struct APIConfigImpl: APIConfig {
    
    let url = "https://randomuser.me/api/"
    let format = "json" //response data format
    let seed = "extdd2017" //unique seed id
    let includeOnly = "login,gender,name,email,phone,picture&noinfo" //response data restrictions
    let nationality = "us" //nationality of users
    let results = 50 //max number of results
    var urlWithParams:String {
        return "\(url)?format=\(format)&seed=\(seed)&results=\(results)&inc=\(includeOnly)&nat=\(nationality)"
    }

}


