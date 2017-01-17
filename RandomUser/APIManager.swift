//
//  APIManager.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import RealmSwift

fileprivate enum APIManagerError: Error {
    
    case NoUsersData
    
}

struct APIManager {
    
    var config:APIConfig!
    var networkManager:NetworkManager!
    
    init(_ config:APIConfig, _ networkManager:NetworkManager) {
        
        self.config = config
        self.networkManager = networkManager
        
    }
    
    func loadUsers() {
        
        networkManager?.loadJSON(url: config!.urlWithParams) { json in
            
            if json != nil {
                
                guard let jsonUsers = json!["results"] else {
                    printError(APIManagerError.NoUsersData)
                    return
                }
                
                do {
                    
                    let users = try [User].decode(jsonUsers)
                    
                    print("users count: \(users.count)")
                    
                } catch {
                    
                    printError(error)
                    
                }
                
            }
            
        }
    }
    
}
