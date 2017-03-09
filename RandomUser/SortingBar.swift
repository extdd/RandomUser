//
//  SortingBar.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 25.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import SnapKit

class SortingBar: UIView {
    
    let segmentedControl: UISegmentedControl
    let items: [String]?
    
    fileprivate let body = UIView(frame: .zero)
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // MARK: - INIT
    
    init(frame: CGRect, withItems items: [String]?) {
        
        self.items = items
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .white
        
        super.init(frame: frame)
        
        body.addSubview(blurView)
        self.addSubview(body)
        self.addSubview(segmentedControl)
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.marginMedium)
            make.bottom.equalToSuperview().inset(Layout.marginMedium)
            make.centerX.equalToSuperview()
        }
        body.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
