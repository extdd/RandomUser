//
//  ManagersAssembly.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Swinject
import RealmSwift

class ManagersAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - API MANAGER
        
        container.register(APIConfig.self) { _ in
            APIConfigImpl()
            }
        
        container.register(APIManager.self) { r in
            APIManagerImpl(r.resolve(APIConfig.self)!, r.resolve(NetworkManager.self)!, r.resolve(Realm.self)!)
            }.inObjectScope(.container)
        
        // MARK: - NETWORK MANAGER
        
        container.register(NetworkManager.self) { _ in
            NetworkManagerImpl()
            }.inObjectScope(.container)
        
        // MARK: - REALM
        
        container.register(Realm.Configuration.self) { _ in
            Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            }.inObjectScope(.container)

        container.register(Realm.self) { r in
            try! Realm(configuration: r.resolve(Realm.Configuration.self)!)
            }
        
    }
    
}

