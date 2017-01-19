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
        
        // Recreating Realm database every run for testing only
        
        if let path = Realm.Configuration.defaultConfiguration.fileURL{
            
            if FileManager().fileExists(atPath: path.relativePath) {
                do {
                    try FileManager().removeItem(at: path.absoluteURL)
                } catch {
                    printError(error)
                }
            }
            
        }
        
        // Loading JSON and saving users data in Realm database
        
        networkManager?.loadJSON(url: config!.urlWithParams) { json in
            
            if json != nil {
                
                guard let jsonUsers = json!["results"] else {
                    printError(APIManagerError.NoUsersData)
                    return
                }
                
                do {
                    
                    let users = try [User].decode(jsonUsers)
                    let realm = try! Realm()
                    
                    try! realm.write {
                        realm.add(users, update: true)
                    }
                    
                    print("users count: \(realm.objects(User.self).count)")
                    
                } catch {
                    printError(error)
                }
                
            }
            
        }
        
    }
    
}
