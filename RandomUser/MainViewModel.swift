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
    var sortingBarItems: [String]? { get }
    var preloaderInfo: PreloaderInfo { get }
    
    func updateUsers(sorted: SortingMode)
    func getCellText(for user: User) -> String
    
}

// MARK: - IMPLEMENTATION

class MainViewModelImpl: MainViewModel {
    
    let apiManager: APIManager
    var users: Results<User>?
    var navigationBarTitle: String = "Users"
    var sortingBarItems: [String]? {
        return SortingMode.all.map { mode -> String in
            switch mode {
            case .firstName: return "First name"
            case .lastName: return "Last name"
            }
        }
    }
    var preloaderInfo: PreloaderInfo {
        if let users = users, users.count > 0 { return .refreshing }
        else { return .loading }
    }
    
    // MARK: - INIT
    
    init(apiManager: APIManager) {
        
        self.apiManager = apiManager
        
    }
    
    // MARK: - UPDATE
    
    func updateUsers(sorted: SortingMode) {
        
        let realm = try! Realm()
        users = realm.objects(User.self).sorted(byKeyPath: sorted.rawValue)
        
    }
    
    // MARK: - UI
    
    func getCellText(for user: User) -> String {
        
        return "\(user.fullName)"
        
    }
    
}
