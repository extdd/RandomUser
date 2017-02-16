//
//  HistoryViewModel.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 15.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//


import Foundation
import RealmSwift

// MARK: - INTERFACE

protocol HistoryViewModel {
    
    var snapshots: List<UserSnapshot>? { get set }
    var navigationBarTitle: String { get set }
    
    func getCellTexts(for snapshot: UserSnapshot) -> (date: String, title: String, gender: String, detail: String?)
    func getGenderLabelColor(for snapshot: UserSnapshot) -> UIColor
    
}

// MARK: - IMPLEMENTATION

struct HistoryViewModelImpl: HistoryViewModel {
    
    var snapshots: List<UserSnapshot>?
    var navigationBarTitle: String = "Change history"
    
    func getCellTexts(for snapshot: UserSnapshot) -> (date: String, title: String, gender: String, detail: String?) {
        
        let date = snapshot.formattedDate
        let title = snapshot.fullName
        let gender = Gender.from(string: snapshot.gender).symbol

        var detail: String = ""
        if let email = snapshot.email { detail.append("\(email)\n") }
        if let phone = snapshot.phone { detail.append("\(phone)") }
        detail = detail.trimmingCharacters(in: .newlines)

        return (date, title, gender, detail)
        
    }
    
    func getGenderLabelColor(for snapshot: UserSnapshot) -> UIColor {
        
        switch Gender.from(string: snapshot.gender) {
        case .male:
            return UIColor(hex: CustomColor.teal)
        case .female:
            return UIColor(hex: CustomColor.violet)
        }
        
    }
    
}

