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
    var users: Results<User>? { get set }
    var navigationBarTitle: String { get set }
    
    mutating func updateUsers(sorted: SortingMode)
    func getCellText(for user: User) -> String
    func getSortingBarItems() -> [String]?
    
}

// MARK: - IMPLEMENTATION

struct MainViewModelImpl: MainViewModel {
    
    let apiManager: APIManager
    var users: Results<User>?
    var navigationBarTitle: String = "Users"
    
    init(apiManager: APIManager) {
        
        self.apiManager = apiManager
        
    }
    
    mutating func updateUsers(sorted: SortingMode) {
        
        let realm = try! Realm()
        users = realm.objects(User.self).sorted(byKeyPath: sorted.rawValue)
        
    }
    
    func getCellText(for user: User) -> String {
        
        return "\(user.fullName)"
        
    }
    
    func getSortingBarItems() -> [String]? {
        
        return SortingMode.all.map { mode -> String in
            switch mode {
            case .firstName:
                return "First name"
            case .lastName:
                return "Last name"
            }
        }
        
    }
    
}
