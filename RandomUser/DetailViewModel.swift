//
//  DetailViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 05.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

// MARK: - INTERFACE

protocol DetailViewModel {

    var activeUser: User? { get set }

    func getTitle(for displayMode: DisplayMode) -> String?
    
}

// MARK: - IMPLEMENTATION

struct DetailViewModelImpl: DetailViewModel {

    var activeUser: User?
    
    func getTitle(for displayMode: DisplayMode) -> String? {
        switch displayMode {
        case .show:
            return "Details"
        case .edit:
            return "Edit user"
        case .add:
            return "New user"
        }
    }
    
}
