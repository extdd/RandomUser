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
            mainViewController.viewModel = r.resolve(MainViewModel.self)!
            mainViewController.apiManager = r.resolve(APIManager.self)!
            return mainViewController
            }
        
        // MARK: - DETAIL VIEW CONTROLLER
        
        container.register(DetailViewController.self) { r in
            let detailViewController = DetailViewController()
            detailViewController.viewModel = r.resolve(DetailViewModel.self)!
            detailViewController.apiManager = r.resolve(APIManager.self)!
            return detailViewController
            }
        
        // MARK: - HISTORY VIEW CONTROLLER
        
        container.register(HistoryViewController.self) { r in
            let historyViewController = HistoryViewController()
            historyViewController.viewModel = r.resolve(HistoryViewModel.self)!
            historyViewController.apiManager = r.resolve(APIManager.self)!
            return historyViewController
        }
        
    }
    
}
