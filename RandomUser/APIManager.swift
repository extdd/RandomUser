//
//  APIManager.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

// MARK: - INTERFACE

protocol APIManager {
    
    var config: APIConfig { get }
    var networkManager: NetworkManager { get }
    var realm: Realm { get }
    
    func loadUsers() -> Observable<[User]>
    func save(user: User, isNew: Bool, gender: Gender, firstName: String, lastName: String, email: String?, phone: String?)
    func getNewUser() -> User
    
}

// MARK: - IMPLEMENTATION

class APIManagerImpl: APIManager {
    
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

    func loadUsers() -> Observable<[User]> {
        
        return networkManager.loadData(url: config.fullURL)
            .map { data -> [User] in

                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                    throw(DataError.InvalidJSON)
                }
                
                guard let results = json["results"] as? [Any] else {
                    throw(DataError.NoUsersData)
                }
                
                let users = try [User].decode(results)
                return users

            }.do(onNext: { users in
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                guard let realm = appDelegate.assembler.resolver.resolve(Realm.self) else { return } // new Realm instance for the new thread
                try realm.write {
                    users.forEach {
                        var isUpdate: Bool = false
                        if let existingUser = realm.object(ofType: User.self, forPrimaryKey: $0.username) { // checking if user exists
                            isUpdate = true
                            $0.snapshots = existingUser.snapshots
                        }
                        realm.add($0, update: isUpdate)
                        UserSnapshot.add(for: $0, in: realm)
                    }
                }
                
            }).observeOn(MainScheduler.instance)
        
    }

    // MARK: - SAVE
    
    func save(user: User, isNew: Bool = false, gender: Gender, firstName: String, lastName: String, email: String? = nil, phone: String? = nil) {
        
        guard !firstName.isEmpty && !lastName.isEmpty else { return }
        
        try! realm.write {

            user.gender = gender.rawValue
            user.firstName = firstName
            user.lastName = lastName
            user.email = (email ?? "").isEmpty ? nil : email
            user.phone = (phone ?? "").isEmpty ? nil : phone
            
            if isNew {
                user.username = getUniqueUsername(forFirstName: user.firstName, withLastName: user.lastName)
            }

            realm.add(user, update: !isNew)
            UserSnapshot.add(for: user, in: realm)
        }
 
    }

    // MARK: - UTILS
    
    func getNewUser() -> User {
        
        return User()
        
    }
    
    fileprivate func usernameExists(_ username: String, in users: Results<User>) -> Bool {
        
        return users
            .map { $0.username.lowercased() }
            .contains(username)
        
    }
    
    fileprivate func getUniqueUsername(forFirstName firstName: String, withLastName lastName: String) -> String {
        
        let users = realm.objects(User.self)
        var username = firstName.appending(lastName).lowercased()

        // appending unique number if username exists in Realm database
        while usernameExists(username, in: users) {
            TextFormatter.appendNumber(to: &username)
        }

        return username
        
    }
    
}
