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
    
    fileprivate var info: PreloaderInfo?
    fileprivate var snapToSuperview: Bool = false
    fileprivate let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let label = UILabel(frame: .zero)
    fileprivate let body = UIView(frame: .zero)
    
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
        label.font = CustomFont.text
        label.textAlignment = .center
        label.textColor = .white
        label.text = info?.rawValue
        body.backgroundColor = .black
        body.alpha = 0.8
        
        self.addSubviews([body, indicator, label])
        setConstraints()
        
    }
    
    // MARK: - CONSTRAINTS
    
    fileprivate func setConstraints() {
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(indicator.snp.bottom).offset(Layout.margin)
        }
        
        body.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

