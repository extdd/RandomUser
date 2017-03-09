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
            MainViewController(viewModel: r.resolve(MainViewModel.self)!, apiManager: r.resolve(APIManager.self)!)
            }
        
        // MARK: - DETAIL VIEW CONTROLLER
        
        container.register(DetailViewController.self) { r in
            DetailViewController(viewModel: r.resolve(DetailViewModel.self)!, apiManager: r.resolve(APIManager.self)!)
            }
        
        // MARK: - HISTORY VIEW CONTROLLER
        
        container.register(HistoryViewController.self) { r in
            HistoryViewController(viewModel: r.resolve(HistoryViewModel.self)!)
            }
        
    }
    
}
