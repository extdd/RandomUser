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
    let nameLabel = UILabel.create(type: .text)
    let detailLabel = UILabel.create(type: .detail, lines: 0)
    let genderLabel = UILabel.create(type: .symbol)
    
    fileprivate let dateBar = UIView(frame: .zero)
    fileprivate let labelsContainer = UIView(frame: .zero)
    fileprivate var didSetupConstraints: Bool = false
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
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
        
        dateBar.backgroundColor = CustomColor.gray
        dateBar.addSubview(dateLabel)
        labelsContainer.addSubviews([nameLabel, detailLabel, genderLabel])
        self.contentView.addSubviews([dateBar, labelsContainer])
        self.layoutIfNeeded()
        
    }
    
    
    //
    // MARK: - CONSTRAINTS
    
    override func updateConstraints() {
        
        setupConstraints()
        super.updateConstraints()
        
    }
    
    fileprivate func setupConstraints() {
        
        guard !didSetupConstraints else { return }
        
        // date
        dateBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.marginExtraSmall)
            make.left.right.equalToSuperview().inset(Layout.margin)
            make.bottom.equalToSuperview().inset(Layout.marginExtraSmall)
        }
        
        // labels
        labelsContainer.snp.makeConstraints { make in
            make.top.equalTo(dateBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView).offset(-Layout.margin)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.marginSmall)
            make.left.equalToSuperview().offset(Layout.margin)
            make.right.lessThanOrEqualTo(genderLabel.snp.left).offset(-Layout.marginSmall)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Layout.marginExtraSmall)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(genderLabel.snp.left).offset(-Layout.marginSmall)
            make.bottom.equalTo(labelsContainer).inset(Layout.marginSmall)
        }
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // compression ressistance
        nameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        didSetupConstraints = true
        
    }
    
}
