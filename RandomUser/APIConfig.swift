//
//  APIConfig.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

struct APIConfig {
    
    let url = "https://randomuser.me/api/"
    
    let format = "json" //response data format
    let seed = "extdd2017" //unique seed id
    let results = 50 //max number of results
    let includeOnly = "login,gender,name,email,phone,picture&noinfo" //response data restrictions
    let nationality = "us" //nationality of users
    
    var urlWithParams:String {
        return "\(url)?format=\(format)&seed=\(seed)&results=\(results)&inc=\(includeOnly)&nat=\(nationality)"
    }
    
}
