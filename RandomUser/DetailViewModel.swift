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
    var navigationBarTitle: String { get set }
    
}

// MARK: - IMPLEMENTATION

struct DetailViewModelImpl: DetailViewModel {
    
    var activeUser: User?
    var navigationBarTitle: String = "User details"
    
}
