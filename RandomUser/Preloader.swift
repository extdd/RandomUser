//
//  Preloader.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 27.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import SnapKit

enum PreloaderInfo: String {
    
    case loading = "Loading..."
    case refreshing = "Refreshing..."
    
}

class Preloader: UIView {
    
    fileprivate let body = UIView(frame: .zero)
    fileprivate let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate var label: UILabel?
    fileprivate var info: PreloaderInfo?
    fileprivate var snapToSuperview: Bool = false
    
    // MARK: - INIT
    
    convenience init(info: PreloaderInfo? = nil, snapToSuperview: Bool = false) {
        
        self.init(frame: .zero)
        self.info = info
        self.snapToSuperview = snapToSuperview
        initUI()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - UI
    
    fileprivate func initUI() {
        
        indicator.startAnimating()
        body.backgroundColor = .black
        body.alpha = 0.8
        self.addSubviews([body, indicator])
        
        if info != nil {
            label = UILabel.create(type: .text, align: .center)
            label!.text = info?.rawValue
            label!.textColor = .white
            self.addSubview(label!)
        }
        
        setConstraints()
        
    }
    
    // MARK: - CONSTRAINTS
    
    fileprivate func setConstraints() {
        
        body.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label?.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(indicator.snp.bottom).offset(Layout.margin)
        }
        
    }

    // MARK: - EVENTS
    
    override func didMoveToSuperview() {
        
        guard superview != nil else { return }
        guard snapToSuperview == true else { return }
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

