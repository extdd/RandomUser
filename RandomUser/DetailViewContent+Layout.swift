//
//  DetailViewContent+Layout.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 26.03.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

extension DetailViewContent {
    
    // MARK: - CONSTRAINTS
    
    override func updateConstraints() {
        
        setupConstraints()
        super.updateConstraints()
        
    }
    
    func updateConstraints(for displayMode: DisplayMode) {
        
        switch (displayMode) {
        case .show:
            guard
                let nameValue = nameValue,
                let genderValue = genderValue,
                let historyButton = historyButton
                else { return }
            
            // name value
            nameValue.snp.remakeConstraints { make in
                make.top.equalTo(nameHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(nameHeader)
            }
            
            // gender value
            genderValue.snp.remakeConstraints { make in
                make.top.equalTo(genderHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(genderHeader)
            }
            
            // email header
            emailHeader?.snp.remakeConstraints { make in
                make.top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderValue)
            }
            
            // email value
            emailValue?.snp.remakeConstraints { make in
                guard emailHeader != nil else { return }
                make.top.equalTo(emailHeader!.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(emailHeader!)
            }
            
            // phone header
            phoneHeader?.snp.remakeConstraints { make in
                let top = make.top
                if emailValue != nil {
                    top.equalTo(emailValue!.snp.bottom).offset(Layout.margin)
                } else {
                    top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                }
                make.left.right.equalTo(genderHeader)
            }
            
            // phone value
            phoneValue?.snp.remakeConstraints { make in
                guard phoneHeader != nil else { return }
                make.top.equalTo(phoneHeader!.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(phoneHeader!)
            }
            
            // history button
            historyButton.snp.remakeConstraints { make in
                let top = make.top
                if phoneValue != nil {
                    top.equalTo(phoneValue!.snp.bottom).offset(Layout.margin)
                } else if emailValue != nil {
                    top.equalTo(emailValue!.snp.bottom).offset(Layout.margin)
                } else {
                    top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                }
                make.left.right.equalTo(genderHeader)
                make.height.equalTo(Layout.buttonHeight)
            }
            
        case .edit, .add:
            guard
                let firstNameInput = firstNameInput,
                let lastNameInput = lastNameInput,
                let genderPickerView = genderPickerView,
                let emailHeader = emailHeader,
                let emailInput = emailInput,
                let emailValidationInfo = emailValidationInfo,
                let phoneHeader = phoneHeader,
                let phoneInput = phoneInput,
                let phoneValidationInfo = phoneValidationInfo
                else { return }
            
            // firstName input
            firstNameInput.snp.remakeConstraints { make in
                make.top.equalTo(nameHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(nameHeader)
            }
            
            // lastName input
            lastNameInput.snp.remakeConstraints { make in
                make.top.equalTo(firstNameInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(nameHeader)
            }
            
            // gender picker
            genderPickerView.snp.remakeConstraints { make in
                make.top.equalTo(genderHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalToSuperview()
                make.height.equalTo(100)
            }
            
            // email header
            emailHeader.snp.remakeConstraints { make in
                make.top.equalTo(genderPickerView.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader)
            }
            
            // email input
            emailInput.snp.remakeConstraints { make in
                make.top.equalTo(emailHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(emailHeader)
            }
            
            // email validationInfo
            emailValidationInfo.snp.remakeConstraints { make in
                make.top.equalTo(emailInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(genderHeader)
            }
            
            // phone header
            phoneHeader.snp.remakeConstraints { make in
                make.top.equalTo(emailValidationInfo.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(genderHeader)
            }
            
            // phone input
            phoneInput.snp.remakeConstraints { make in
                make.top.equalTo(phoneHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(phoneHeader)
            }
            
            // phone validationInfo
            phoneValidationInfo.snp.remakeConstraints { make in
                make.top.equalTo(phoneInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(genderHeader)
            }
            
        }
        
    }
    
    fileprivate func setupConstraints() {
        
        guard !didSetupConstraints else { return }
        
        // picture
        pictureImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.topMargin)
            make.left.equalTo(snp.leftMargin)
            make.width.height.equalTo(snp.width).multipliedBy(0.3)
        }
        
        // name header
        nameHeader.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.margin)
            make.left.equalTo(pictureImageView.snp.right).offset(Layout.margin)
            make.right.equalTo(snp.rightMargin)
        }
        
        // gender header
        genderHeader.snp.makeConstraints { make in
            make.top.equalTo(pictureImageView.snp.bottom).offset(Layout.margin)
            make.left.equalTo(snp.leftMargin)
            make.right.equalTo(snp.rightMargin)
        }
        
        didSetupConstraints = true
        
    }
    
}

