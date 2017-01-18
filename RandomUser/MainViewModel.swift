//
//  MainViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

// MARK: - INTERFACE

protocol MainViewModel {
    
    func initData()
    
}

// MARK: - IMPLEMENTATION

struct MainViewModelImpl: MainViewModel {
    
    var apiManager:APIManager?
    
    init(_ apiManager:APIManager){
        
        self.apiManager = apiManager
        
    }
    
    func initData() {
        
        apiManager?.loadUsers()
        
    }

}
