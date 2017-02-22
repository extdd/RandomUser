//
//  DetailViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 05.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

// MARK: - INTERFACE

protocol DetailViewModel {

    var activeUser: User? { get set }
    
    var firstName: Variable<String?> { get }
    var lastName: Variable<String?> { get }
    var email: Variable<String?> { get }
    var phone: Variable<String?> { get }
    
    var saveValidation: Observable<Bool> { get set }
    var emailValidation: Observable<Bool> { get set }
    var phoneValidation: Observable<Bool> { get set }
    
    func getTitle(for displayMode: DisplayMode) -> String?
    
}

// MARK: - IMPLEMENTATION

class DetailViewModelImpl: DetailViewModel {

    var activeUser: User?
    
    let firstName = Variable<String?>(nil)
    let lastName = Variable<String?>(nil)
    let email = Variable<String?>(nil)
    let phone = Variable<String?>(nil)
    
    // save validation

    lazy var saveValidation: Observable<Bool> = { [unowned self] in
        return Observable
            .combineLatest(self.firstNameValidation,
                           self.lastNameValidation,
                           self.emailValidation,
                           self.phoneValidation) {
                $0 && $1 && $2 && $3
            }.distinctUntilChanged()
    }()
    
    // email validation
    
    lazy var emailValidation: Observable<Bool> = {
        return self.email
            .asObservable()
            .filterNil()
            .map {
                // check is empty or valid
                return $0.characters.count == 0 || $0.checkFormat(for: .email)
            }.distinctUntilChanged()
    }()
    
    // phone validation
    
    lazy var phoneValidation: Observable<Bool> = {
        return self.phone
            .asObservable()
            .filterNil()
            .map {
                // check is empty or valid
                return $0.characters.count == 0 || $0.characters.count >= 9
            }.distinctUntilChanged()
    }()
    
    // firstName validation
    
    fileprivate lazy var firstNameValidation: Observable<Bool> = {
        return self.firstName
            .asObservable()
            .filterNil()
            .map {
                // check is not empty
                !$0.isEmpty
            }.distinctUntilChanged()
    }()
    
    // lastName validation
    
    fileprivate lazy var lastNameValidation: Observable<Bool> = {
        return self.lastName
            .asObservable()
            .filterNil()
            .map {
                // check is not empty
                !$0.isEmpty
            }.distinctUntilChanged()
    }()
    
    // title
    
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
