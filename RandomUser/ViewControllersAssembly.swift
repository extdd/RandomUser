//
//  ViewControllersAssembly.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Swinject

class ViewControllersAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - MAIN VIEW CONTROLLER
        
        container.register(MainViewController.self) { r in
            
            let mainViewController = MainViewController()
            mainViewController.mainViewModel = r.resolve(MainViewModel.self)!
            return mainViewController
            
        }
        
    }
    
}
