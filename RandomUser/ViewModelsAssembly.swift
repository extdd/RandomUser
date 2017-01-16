//
//  ViewModelsAssembly.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Swinject

class ViewModelsAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - MAIN VIEW MODEL
        
        container.register(MainViewModel.self) { r in
            
            let mainViewModel = MainViewModelImpl()
            return mainViewModel
            
        }
        
    }
    
}
