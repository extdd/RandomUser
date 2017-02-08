//
//  DetailViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 05.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - INTERFACE

protocol DetailViewModel {
    
    var realm: Realm { get }
    
    var activeUser: User? { get set }
    var navigationBarTitle: String { get set }
    
    func save(gender: String?, firstName: String?, lastName: String?, email: String?, phone: String?)
    
}

// MARK: - IMPLEMENTATION

struct DetailViewModelImpl: DetailViewModel {

    let realm: Realm
    
    var activeUser: User?
    var navigationBarTitle: String = "User details"
    
    init(_ realm: Realm) {
        
        self.realm = realm
        
    }
    
    func save(gender: String? = nil,
              firstName: String? = nil,
              lastName: String? = nil,
              email: String? = nil,
              phone: String? = nil) {
        
        guard let user = activeUser else { return }
        
        try! realm.write {
            if gender != nil { user.gender = gender! }
            if firstName != nil { user.firstName = firstName! }
            if lastName != nil { user.lastName = lastName! }
            if email != nil { user.email = email! }
            if phone != nil { user.phone = phone! }   
        }
        
    }
    
}
