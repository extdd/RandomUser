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
    
    var pictureImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: CustomImage.userDefaultPictureName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var firstNameInput: UITextField?
    var lastNameInput: UITextField?
    var emailInput: UITextField?
    var phoneInput: UITextField?
    
    var emailValidationInfo: UILabel?
    var phoneValidationInfo: UILabel?
    
    var genderPickerView: UIPickerView?
    var historyButton: UIButton?
    
    // collection for an always visible subviews (picture & headers) in both display modes (show / edit)
    
    fileprivate var constantSubviews: [UIView] = []
    
    // private UI controls & views

    fileprivate let userDefaultPicture: UIImage? = UIImage(named: CustomImage.userDefaultPictureName)
    
    fileprivate let nameHeader: UILabel = UILabel.create(text: "Name:", type: .header)
    fileprivate let genderHeader: UILabel = UILabel.create(text: "Gender:", type: .header)
    fileprivate var emailHeader: UILabel?
    fileprivate var phoneHeader: UILabel?
    
    fileprivate var nameValue: UILabel?
    fileprivate var genderValue: UILabel?
    fileprivate var emailValue: UILabel?
    fileprivate var phoneValue: UILabel?
    
    // MARK: - INIT
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    // MARK: - UI

    func updateUI(for displayMode: DisplayMode, with user: User) {
        
        clearUI()
        
        // picture
        if let pictureURL = user.pictureURL {
            pictureImageView.sd_setImage(with: URL(string: pictureURL), placeholderImage: userDefaultPicture)
        }

        // optional headers
        if user.email != nil || displayMode != .show {
            emailHeader = UILabel.create(text: "Email:", type: .header)
            self.addSubview(emailHeader!)
        }
        if user.phone != nil || displayMode != .show {
            phoneHeader = UILabel.create(text: "Phone:", type: .header)
            self.addSubview(phoneHeader!)
        }
        
        switch (displayMode) {
        case .show:
            
            // value labels
            nameValue = UILabel.create(text: user.fullName, lines: 2)
            genderValue = UILabel.create(text: user.gender)
            emailValue = (user.email != nil) ? UILabel.create(text: user.email) : nil
            phoneValue = (user.phone != nil) ? UILabel.create(text: user.phone) : nil
   
            // history button
            historyButton = UIButton(type: UIButtonType.system)
            historyButton!.setTitle("Change history", for: .normal)
            historyButton!.setTitleColor(.white, for: .normal)
            historyButton!.titleLabel?.font = CustomFont.text
            historyButton!.backgroundColor = CustomColor.defaultTint
            
            self.addSubviews([
                nameValue,
                genderValue,
                emailValue,
                phoneValue,
                historyButton
                ])
            
        case .edit, .add:
            
            // firstName input
            firstNameInput = UITextField.create(text: user.firstName, placeholder: "First name", capitalized: true)
            firstNameInput!.returnKeyType = .next
            
            // lastName input
            lastNameInput = UITextField.create(text: user.lastName, placeholder: "Last name", capitalized: true)
            lastNameInput!.returnKeyType = .next
            
            // email input
            emailInput = UITextField.create(text: user.email, placeholder: "Email address", keyboard: .emailAddress)
            emailInput!.returnKeyType = .next
            
            // phone input
            phoneInput = UITextField.create(text: user.phone, placeholder: "Phone number", keyboard: .phonePad)
            
            // validation labels
            emailValidationInfo = UILabel.create(text: "Enter a valid email address", type: .validationInfo)
            phoneValidationInfo = UILabel.create(text: "Enter a valid phone number", type: .validationInfo)
            
            // gender picker
            genderPickerView = UIPickerView(frame: .zero)
            genderPickerView!.backgroundColor = .white
            genderPickerView!.showsSelectionIndicator = true
            genderPickerView!.selectRow(0, inComponent: 0, animated: false)
            
            // first responder
            if user.firstName.isEmpty {
                firstNameInput!.becomeFirstResponder()
            }
            
            self.addSubviews([
                firstNameInput!,
                lastNameInput!,
                emailInput!,
                emailValidationInfo!,
                phoneInput!,
                phoneValidationInfo!,
                genderPickerView!
                ])
            
        }
        
        updateConstraints(for: displayMode)
        
    }
    
    fileprivate func initUI() {
        
        constantSubviews = [pictureImageView, nameHeader, genderHeader]
        self.addSubviews(constantSubviews)
        self.layoutMargins = UIEdgeInsets(all: Layout.margin)
        
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
    
        self.layoutIfNeeded()

    }
    
    // MARK: - CLEAR UI
    
    fileprivate func clearUI() {
        
        // removing non-constant (dynamic) subviews
        self.subviews
            .filter {
                return !constantSubviews.contains($0)
            }.forEach {
                $0.removeFromSuperview()
            }
        
        emailHeader = nil
        phoneHeader = nil
        
        nameValue = nil
        genderValue = nil
        emailValue = nil
        phoneValue = nil
        
        firstNameInput = nil
        lastNameInput = nil
        emailInput = nil
        phoneInput = nil
        
        emailValidationInfo = nil
        phoneValidationInfo = nil
        
        genderPickerView = nil
        historyButton = nil
        
    }
    
}
