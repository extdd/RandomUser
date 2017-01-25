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
    let items: [String]
    
    var body: UIView?
    var blurView: UIVisualEffectView?
    
    // MARK: - INIT
    
    init(frame: CGRect, withItems items: [String]) {
        
        self.items = items
        
        // SEGMENTED CONTROL
        
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor(hex: CustomColor.violet)
        
        super.init(frame: frame)
        self.addSubview(segmentedControl)
        
        // BODY
        
        body = UIView(frame: .zero)
        self.addSubview(body!)
        self.sendSubview(toBack: body!)

        // BLUR EFFECT
        
        let blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        body!.addSubview(blurView!)
        
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
       
        segmentedControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        body?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(segmentedControl.snp.height).offset(Layout.padding*2)
        }
        
    }
    
}
