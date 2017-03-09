//
//  ViewModelsAssembly.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Swinject
import RealmSwift

class ViewModelsAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - MAIN VIEW MODEL
        
        container.register(MainViewModel.self) { _ in
            MainViewModelImpl()
            }
        
        // MARK: - DETAIL VIEW MODEL
        
        container.register(DetailViewModel.self) { _ in
            DetailViewModelImpl()
            }
        
        // MARK: - HISTORY VIEW MODEL
        
        container.register(HistoryViewModel.self) { _ in
            HistoryViewModelImpl()
            }
        
    }
    
}
