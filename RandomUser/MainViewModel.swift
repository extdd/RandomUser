//
//  MainViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

enum SortingMode: String {
    
    case firstName = "firstName", lastName = "lastName"
    
}

// MARK: - INTERFACE

protocol MainViewModel {
    
    func initData()
    func getCellLabel(forUser user:User) -> String
    
}

// MARK: - IMPLEMENTATION

struct MainViewModelImpl: MainViewModel {
    
    var apiManager:APIManager
    
    init(_ apiManager:APIManager){
        
        self.apiManager = apiManager
        
    }
    
    func initData() {
        
        apiManager.loadUsers()
        
    }
    
    func getCellLabel(forUser user:User) -> String {
        
        return "\(user.firstName.capitalized) \(user.lastName.capitalized)"
        
    }
    
}
