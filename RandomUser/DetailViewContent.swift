//
//  DetailContent.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 05.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewContent: UIView {
    
    // internal UI controls
    
    lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: CustomImage.userDefaultPictureName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var firstNameInput: UITextField?
    var lastNameInput: UITextField?
    var emailInput: UITextField?
    var emailValidationInfo: UILabel?
    var phoneInput: UITextField?
    var phoneValidationInfo: UILabel?
    var genderPickerView: UIPickerView?
    var historyButton: UIButton?
    
    // collection for an always visible subviews (picture & headers) in both display modes (show / edit)
    
    fileprivate var constantSubviews: [UIView] = []
    
    // private UI controls & views

    fileprivate lazy var userDefaultPicture: UIImage? = UIImage(named: CustomImage.userDefaultPictureName)
    fileprivate lazy var nameHeader: UILabel = UILabel.create(text: "Name:", type: .header)
    fileprivate lazy var genderHeader: UILabel = UILabel.create(text: "Gender:", type: .header)
    
    fileprivate var nameValue: UILabel?
    fileprivate var genderValue: UILabel?
    fileprivate var emailHeader: UILabel?
    fileprivate var emailValue: UILabel?
    fileprivate var phoneHeader: UILabel?
    fileprivate var phoneValue: UILabel?
    
    // MARK: - INIT
    
    func initUI() {
        
        constantSubviews = [pictureImageView, nameHeader, genderHeader]
        self.addSubviews(constantSubviews)
        self.layoutMargins = UIEdgeInsets(all: Layout.margin)
        
    }
    
    // MARK: - UPDATE UI

    func update(for displayMode: DisplayMode, with user: User) {
        
        clear()
        
        // setting picture
        if let pictureURL = user.pictureURL {
            pictureImageView.sd_setImage(with: URL(string: pictureURL), placeholderImage: userDefaultPicture)
        }

        // creating optional headers
        if user.email != nil || displayMode != .show { emailHeader = UILabel.create(text: "Email:", type: .header) }
        if user.phone != nil || displayMode != .show { phoneHeader = UILabel.create(text: "Phone:", type: .header) }
        self.addSubviews([emailHeader, phoneHeader])
        
        switch (displayMode) {
        case .show:
            // creating labels
            nameValue = UILabel.create(text: user.fullName, lines: 2)
            genderValue = UILabel.create(text: user.gender)
            if user.email != nil { emailValue = UILabel.create(text: user.email) }
            if user.phone != nil { phoneValue = UILabel.create(text: user.phone) }
            // creating history button
            historyButton = UIButton(type: UIButtonType.system)
            historyButton!.setTitle("Change history", for: .normal)
            historyButton!.setTitleColor(.white, for: .normal)
            historyButton!.titleLabel?.font = CustomFont.text
            historyButton!.backgroundColor = CustomColor.defaultTint
            // adding subviews to the view
            self.addSubviews([
                nameValue,
                genderValue,
                emailValue,
                phoneValue,
                historyButton
                ])
            
        case .edit, .add:
            // creating inputs
            firstNameInput = UITextField.create(placeholder: "First name", capitalized: true)
            lastNameInput = UITextField.create(placeholder: "Last name", capitalized: true)
            emailInput = UITextField.create(placeholder: "Email address", keyboard: .emailAddress)
            phoneInput = UITextField.create(placeholder: "Phone number", keyboard: .phonePad)
            // setting return key type
            firstNameInput!.returnKeyType = .next
            lastNameInput!.returnKeyType = .next
            emailInput!.returnKeyType = .next
            // creating validation labels
            emailValidationInfo = UILabel.create(text: "Enter a valid email address", type: .validationInfo)
            phoneValidationInfo = UILabel.create(text: "Enter a valid phone number", type: .validationInfo)
            // creating gender picker
            genderPickerView = UIPickerView(frame: .zero)
            genderPickerView?.backgroundColor = .white
            genderPickerView?.showsSelectionIndicator = true
            genderPickerView?.selectRow(0, inComponent: 0, animated: false)
            // adding subviews to the view
            self.addSubviews([
                firstNameInput!,
                lastNameInput!,
                emailInput!,
                emailValidationInfo!,
                phoneInput!,
                phoneValidationInfo!,
                genderPickerView!
                ])
            
            fallthrough
            
        case .edit:
            guard displayMode == .edit else { fallthrough }
            // setting current values to the inputs
            firstNameInput!.text = user.firstName
            lastNameInput!.text = user.lastName
            emailInput!.text = user.email
            phoneInput!.text = user.phone
            
        case .add:
            // setting auto focus to the first input
            firstNameInput!.becomeFirstResponder()
        }
        
        updateConstraints(for: displayMode)
        
    }
    
    // MARK: - CONSTRAINTS
    
    func updateConstraints(for displayMode: DisplayMode) {
        
        // picture
        pictureImageView.snp.remakeConstraints { make in
            make.top.equalTo(snp.topMargin)
            make.left.equalTo(snp.leftMargin)
            make.width.height.equalTo(snp.width).multipliedBy(0.3)
        }

        // name header
        nameHeader.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(Layout.margin)
            make.left.equalTo(pictureImageView.snp.right).offset(Layout.margin)
            make.right.equalTo(snp.rightMargin)
        }
        
        // gender header
        genderHeader.snp.remakeConstraints { make in
            make.top.equalTo(pictureImageView.snp.bottom).offset(Layout.margin)
            make.left.equalTo(snp.leftMargin)
            make.right.equalTo(snp.rightMargin)
        }
        
        switch (displayMode) {
        case .show:
            guard
                let nameValue = nameValue,
                let genderValue = genderValue,
                let historyButton = historyButton
                else { return }
            
            // name
            nameValue.snp.remakeConstraints { make in
                make.top.equalTo(nameHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(nameHeader)
            }
            
            // gender
            genderValue.snp.remakeConstraints { make in
                make.top.equalTo(genderHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(genderHeader)
            }
            
            // email
            emailHeader?.snp.remakeConstraints { make in
                make.top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderValue)
            }
            
            emailValue?.snp.remakeConstraints { make in
                guard emailHeader != nil else { return }
                make.top.equalTo(emailHeader!.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(emailHeader!)
            }
            
            // phone
            phoneHeader?.snp.remakeConstraints { make in
                let top = make.top
                if emailValue != nil {
                    top.equalTo(emailValue!.snp.bottom).offset(Layout.margin)
                } else {
                    top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                }
                make.left.right.equalTo(genderHeader)
            }
            
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
            
            // name
            firstNameInput.snp.remakeConstraints { make in
                make.top.equalTo(nameHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(nameHeader)
            }
            lastNameInput.snp.remakeConstraints { make in
                make.top.equalTo(firstNameInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(nameHeader)
            }
            
            // gender
            genderPickerView.snp.remakeConstraints { make in
                make.top.equalTo(genderHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalToSuperview()
                make.height.equalTo(100)
            }
            
            // email
            emailHeader.snp.remakeConstraints { make in
                make.top.equalTo(genderPickerView.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader)
            }
            emailInput.snp.remakeConstraints { make in
                make.top.equalTo(emailHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(emailHeader)
            }
            emailValidationInfo.snp.remakeConstraints { make in
                make.top.equalTo(emailInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(genderHeader)
            }
            
            // phone
            phoneHeader.snp.remakeConstraints { make in
                make.top.equalTo(emailValidationInfo.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(genderHeader)
            }
            phoneInput.snp.remakeConstraints { make in
                make.top.equalTo(phoneHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(phoneHeader)
            }
            phoneValidationInfo.snp.remakeConstraints { make in
                make.top.equalTo(phoneInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(genderHeader)
            }
        }
    
        self.layoutIfNeeded()

    }
    
    // MARK: - CLEAR
    
    func clear() {
        
        // removing non-constant (dynamic) subviews
        self.subviews.filter({
            for item in constantSubviews { if $0 == item {return false} }
            return true
        }).forEach({
            $0.removeFromSuperview()
        })
        
        nameValue = nil
        genderValue = nil
        emailHeader = nil
        emailValue = nil
        phoneHeader = nil
        phoneValue = nil
        historyButton = nil
        
        firstNameInput = nil
        lastNameInput = nil
        genderPickerView = nil
        emailInput = nil
        emailValidationInfo = nil
        phoneInput = nil
        phoneValidationInfo = nil
        
    }
    
}
