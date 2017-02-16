//
//  APIManager.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - INTERFACE

protocol APIManager {
    
    var config: APIConfig { get }
    var networkManager: NetworkManager { get }
    var realm: Realm { get }
    
    func loadUsers()
    func save(user: User, isNew: Bool, gender: Gender, firstName: String, lastName: String, email: String?, phone: String?)
    func getNewUser() -> User
    
}

// MARK: - IMPLEMENTATION

struct APIManagerImpl: APIManager {
    
    let config: APIConfig
    let networkManager: NetworkManager
    let realm: Realm
    
    // MARK: - INIT
    
    init(config: APIConfig, networkManager: NetworkManager, realm: Realm) {
        
        self.config = config
        self.networkManager = networkManager
        self.realm = realm
        
    }
    
    // MARK: - LOAD
    
    func loadUsers() {
        
        // loading JSON and saving users data in Realm database
        networkManager.loadJSON(url: config.urlWithParams) { json in
            if json != nil {
                guard let jsonUsers = json!["results"] else {
                    print(NetworkDataError.NoUsersData)
                    return
                }
                do {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let realm = appDelegate.assembler.resolver.resolve(Realm.self)! // new Realm instance for the new thread
                    let users = try [User].decode(jsonUsers)

                    try! realm.write {
                        users.forEach {
                            
                            // checking if user exists
                            var isUpdate: Bool = false
                            if let existingUser = realm.object(ofType: User.self, forPrimaryKey: $0.username) {
                                isUpdate = true
                                $0.snapshots = existingUser.snapshots
                            }
                            
                            realm.add($0, update: isUpdate)
                            
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        
    }

    // MARK: - SAVE
    
    func save(user: User, isNew: Bool = false, gender: Gender, firstName: String, lastName: String, email: String? = nil, phone: String? = nil) {
        
        // save a snapshot of changed user data
        let snapshot = UserSnapshot(gender: gender.rawValue, username: user.username, firstName: firstName, lastName: lastName, email: email, phone: phone)
        // compare a snapshot with current user data (before update)
        let changed: Bool = !(snapshot == user)
        
        let realm = try! Realm()
        try! realm.write {

            user.gender = gender.rawValue
            user.firstName = firstName
            user.lastName = lastName
            if email != "" { user.email = email } else { user.email = nil }
            if phone != "" { user.phone = phone } else { user.phone = nil }
            
            if isNew {
                user.username = getUniqueUsername(forFirstName: user.firstName, withLastName: user.lastName)
            } else if changed {
                // if any user data changed, add a new snapshot
                user.snapshots.append(snapshot)
            }
            
            realm.add(user, update: !isNew)
            
        }
 
    }

    // MARK: - UTILS
    
    func getNewUser() -> User {
        
        return User()
        
    }
    
    fileprivate func getUniqueUsername(forFirstName firstName: String, withLastName lastName: String) -> String {
        
        let realm = try! Realm()
        let users = realm.objects(User.self)
        var uniqueUsername = firstName.appending(lastName).lowercased()
        
        // checking username exists in Realm database
        var isExists: Bool = true
        existsLoop: while isExists {
            
            for user in users {
                // if exists, creating new one
                if user.username.lowercased() == uniqueUsername {
                    isExists = true
                    uniqueUsername.addNumber()
                    continue existsLoop
                }
            }
            
            isExists = false
            
        }
        
        return uniqueUsername
        
    }
    
}
