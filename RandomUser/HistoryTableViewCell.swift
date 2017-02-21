//
//  HistoryTableViewCell.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import SnapKit

class HistoryTableViewCell: UITableViewCell {
    
    let dateLabel = UILabel.create(type: .date)
    let titleLabel = UILabel.create(type: .title)
    let detailLabel = UILabel.create(type: .detail)
    let genderLabel = UILabel.create(type: .gender)
    
    fileprivate let dateBar = UIView(frame: .zero)
    fileprivate let content = UIView(frame: .zero)

    // MARK: - INIT
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        initUI()
        
    }
    
    // MARK: - UI
    
    func initUI() {
        
        dateBar.backgroundColor = CustomColor.dark
        dateBar.addSubview(dateLabel)
        content.addSubviews([titleLabel, detailLabel, genderLabel])
        self.addSubviews([dateBar, content])
        setConstraints()
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        // date
        dateBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(Layout.margin)
            make.top.equalTo(dateBar).offset(Layout.marginExtraSmall)
            make.bottom.equalTo(dateBar).inset(Layout.marginExtraSmall)
        }
        
        // content
        content.snp.makeConstraints { make in
            make.top.equalTo(dateBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.marginSmall)
            make.left.equalToSuperview().offset(Layout.margin)
            make.right.lessThanOrEqualTo(genderLabel.snp.left).offset(-Layout.marginSmall)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.marginExtraSmall)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(Layout.marginSmall)
        }
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self).offset(-Layout.margin)
        }
        
    }
    
}

// MARK: - UI LABEL EXTENSION

fileprivate extension UILabel {
    
    class func create(type: LabelType) -> UILabel {
        
        let label = UILabel(frame: .zero)
        var font: UIFont
        
        switch type {
        case .date:
            font = CustomFont.date
            label.textColor = .white
            label.textAlignment = .center
            
        case .title:
            font = CustomFont.header
            label.textColor = CustomColor.text
            
        case .detail:
            font = CustomFont.detail
            label.textColor = CustomColor.text
            label.numberOfLines = 0
            
        case .gender:
            font = CustomFont.symbol
            label.textColor = .lightGray
            label.textAlignment = .center
        }
        
        label.font = font
        return label
        
    }
    
}
