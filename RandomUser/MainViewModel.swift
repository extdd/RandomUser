//
//  MainViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - INTERFACE

protocol MainViewModel {
    
    var apiManager: APIManager { get }
    var realm: Realm { get }
    var users: Results<User>? { get set }
    
    var navigationBarTitle: String { get set }

    func initUsers()
    mutating func updateUsers(sorted: SortingMode)
    func getCellLabel(forUser user: User) -> String
    
}

// MARK: - IMPLEMENTATION

struct MainViewModelImpl: MainViewModel {
    
    let apiManager: APIManager
    let realm: Realm
    var users: Results<User>?
    
    var navigationBarTitle: String = "Users"
    
    init(_ apiManager: APIManager, _ realm: Realm) {
        
        self.apiManager = apiManager
        self.realm = realm
        
    }
    
    func initUsers() {
        
        apiManager.loadUsers()
        
    }
    
    mutating func updateUsers(sorted: SortingMode) {
        
        users = realm.objects(User.self).sorted(byKeyPath: sorted.rawValue)
        
    }
    
    func getCellLabel(forUser user:User) -> String {
        
        return "\(user.firstName.capitalized) \(user.lastName.capitalized)"
        
    }
    
}
