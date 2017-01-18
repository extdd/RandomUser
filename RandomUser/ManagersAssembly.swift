//
//  ManagersAssembly.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Swinject

class ManagersAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - API CONFIG
        
        container.register(APIConfig.self) { _ in
            APIConfig()
            }.inObjectScope(.container)
        
        // MARK: - API MANAGER
        
        container.register(APIManager.self) { r in
            APIManager(r.resolve(APIConfig.self)!, r.resolve(NetworkManager.self)!)
            }.inObjectScope(.container)
        
        // MARK: - NETWORK MANAGER
        
        container.register(NetworkManager.self) { _ in
            NetworkManagerImpl()
            }.inObjectScope(.container)
        
    }
    
}

