//
//  UIView+Ext.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 07.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit

// MARK: - UI VIEW EXTENSIONS

extension UIView {
    
    var realContentSize: CGSize {
        get {
            return self.subviews.reduce(CGRect.zero, { $0.union($1.frame) }).size
        }
    }
    
    func addSubviews(_ views: [UIView?]) {

        views.flatMap{ $0 }.forEach{ self.addSubview($0) }

    }
    
}

// MARK: - UI NAVIGATION CONTROLLER

extension UINavigationController {

    convenience init(rootViewController: UIViewController, customized: Bool = false) {
        
        self.init(rootViewController: rootViewController)
        guard customized == true else { return }
        self.navigationBar.barStyle = .black
        self.navigationBar.tintColor = CustomColor.navigationTint
        
    }
    
}

// MARK: - SUPPORTING EXTENSIONS

extension UIEdgeInsets {
    
    init(all: CGFloat) {
        
        self.init(top: all, left: all, bottom: all, right: all)
        
    }
    
}
