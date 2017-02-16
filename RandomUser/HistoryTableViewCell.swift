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
    
    var dateBar = UIView(frame: .zero)
    var content = UIView(frame: .zero)
    var dateLabel = UILabel.create(type: .date)
    var titleLabel = UILabel.create(type: .title)
    var detailLabel = UILabel.create(type: .detail)
    var genderLabel = UILabel.create(type: .gender)
    
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
        
        dateBar.backgroundColor = UIColor(hex: CustomColor.violetDark)
        dateBar.addSubview(dateLabel)
        content.addSubviews([titleLabel, detailLabel, genderLabel])
        self.addSubviews([dateBar, content])
        setConstraints()
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        // dateBar
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

fileprivate enum LabelType {
    
    case date, title, detail, gender
    
}

fileprivate extension UILabel {
    
    class func create(type: LabelType) -> UILabel {
        
        let label = UILabel(frame: .zero)
        var font: UIFont
        
        switch type {
        case .date:
            font = Font.date
            label.textColor = .white
            label.textAlignment = .center
        case .title:
            font = Font.header
            label.textColor = UIColor(hex: CustomColor.text)
        case .detail:
            font = Font.detail
            label.textColor = UIColor(hex: CustomColor.text)
            label.numberOfLines = 0
        case .gender:
            font = Font.symbol
            label.textColor = .lightGray
            label.textAlignment = .center
        }
        
        label.font = font
        return label
        
    }
    
}

