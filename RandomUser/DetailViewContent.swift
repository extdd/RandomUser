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
    var phoneInput: UITextField?
    var genderPickerView: UIPickerView?
    var historyButton: UIButton?
    
    // collection for an always visible subviews (picture & headers) in both display modes (show / edit)
    
    fileprivate var constantSubviews: [UIView] = []
    
    // private UI controls & views

    fileprivate lazy var userDefaultPicture: UIImage? = UIImage(named: CustomImage.userDefaultPictureName)
    fileprivate lazy var nameHeader: UILabel = UILabel.create(text: "Name:", header: true)
    fileprivate lazy var genderHeader: UILabel = UILabel.create(text: "Gender:", header: true)
    fileprivate lazy var emailHeader: UILabel = UILabel.create(text: "E-mail:", header: true)
    fileprivate lazy var phoneHeader: UILabel = UILabel.create(text: "Phone:", header: true)
    
    fileprivate var nameValue: UILabel?
    fileprivate var genderValue: UILabel?
    fileprivate var emailValue: UILabel?
    fileprivate var phoneValue: UILabel?
    
    // MARK: - INIT
    
    func initUI() {
        
        constantSubviews = [pictureImageView, nameHeader, genderHeader, emailHeader, phoneHeader]
        self.addSubviews(constantSubviews)
        self.layoutMargins = UIEdgeInsets(all: Layout.margin)
        
    }
    
    // MARK: - UPDATE UI
    
    func update(for displayMode: DisplayMode, with user: User) {
        
        clear()
        
        if let pictureURL = user.pictureURL {
            pictureImageView.sd_setImage(with: URL(string: pictureURL), placeholderImage: userDefaultPicture)
        }
        
        switch (displayMode) {
        case .show:
            // creating labels
            nameValue = UILabel.create(text: user.fullName)
            genderValue = UILabel.create(text: user.gender)
            emailValue = UILabel.create(text: user.email)
            phoneValue = UILabel.create(text: user.phone)
            // creating history button
            historyButton = UIButton(type: UIButtonType.system)
            historyButton!.setTitle("Change history", for: .normal)
            historyButton!.setTitleColor(.white, for: .normal)
            historyButton!.titleLabel?.font = CustomFont.text
            historyButton!.backgroundColor = CustomColor.defaultTint
            self.addSubviews([nameValue!, genderValue!, emailValue!, phoneValue!, historyButton!])
            
        case .edit, .add:
            // creating inputs
            firstNameInput = UITextField.create(placeholder: "First name", capitalized: true)
            lastNameInput = UITextField.create(placeholder: "Last name", capitalized: true)
            emailInput = UITextField.create(placeholder: "E-mail address", capitalized: true, keyboard: .emailAddress)
            phoneInput = UITextField.create(placeholder: "Phone number", capitalized: true, keyboard: .namePhonePad)
            // creating gender picker
            genderPickerView = UIPickerView(frame: .zero)
            genderPickerView!.backgroundColor = .white
            genderPickerView!.showsSelectionIndicator = true
            genderPickerView!.selectRow(Gender.from(string: user.gender).hashValue, inComponent: 0, animated: false)
            self.addSubviews([firstNameInput!, lastNameInput!, emailInput!, phoneInput!, genderPickerView!])
            fallthrough
            
        case .edit:
            guard displayMode == .edit else { fallthrough }
            firstNameInput!.text = user.firstName
            lastNameInput!.text = user.lastName
            emailInput!.text = user.email
            phoneInput!.text = user.phone
            
        case .add:
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
                let emailValue = emailValue,
                let phoneValue = phoneValue,
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
            
            // contact
            emailHeader.snp.remakeConstraints { make in
                make.top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderValue)
            }
            emailValue.snp.remakeConstraints { make in
                make.top.equalTo(emailHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(emailHeader)
            }
            phoneHeader.snp.remakeConstraints { make in
                make.top.equalTo(emailValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader)
            }
            phoneValue.snp.remakeConstraints { make in
                make.top.equalTo(phoneHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(phoneHeader)
            }
            
            // history button
            historyButton.snp.remakeConstraints { make in
                make.top.equalTo(phoneValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(phoneHeader)
                make.height.equalTo(40)
            }
            
        case .edit, .add:
            guard
                let firstNameInput = firstNameInput,
                let lastNameInput = lastNameInput,
                let genderPickerView = genderPickerView,
                let emailInput = emailInput,
                let phoneInput = phoneInput
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
            
            // contact
            emailHeader.snp.remakeConstraints { make in
                make.top.equalTo(genderPickerView.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader)
            }
            emailInput.snp.remakeConstraints { make in
                make.top.equalTo(emailHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(emailHeader)
            }
            phoneHeader.snp.remakeConstraints { make in
                make.top.equalTo(emailInput.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader)
            }
            phoneInput.snp.remakeConstraints { make in
                make.top.equalTo(phoneHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(phoneHeader)
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
        
        (nameValue, genderValue, phoneValue, emailValue, historyButton) = (nil, nil, nil, nil, nil)
        (firstNameInput, lastNameInput, genderPickerView, emailInput, phoneInput) = (nil, nil, nil, nil, nil)
        
    }
    
}

// MARK: - UI CONTROLS EXTENSIONS

fileprivate extension UILabel {
    
    class func create(text: String? = nil, header: Bool = false) -> UILabel {
        
        let label = UILabel(frame: .zero)
        
        if text != nil { label.text = text }
        if header { label.font = CustomFont.header }
        else { label.font = CustomFont.text }
        
        label.textColor = CustomColor.text
        label.sizeToFit()
        return label
        
    }
    
}

fileprivate extension UITextField {
    
    class func create(text: String? = nil, placeholder: String? = nil, capitalized: Bool? = false, keyboard: UIKeyboardType? = nil) -> UITextField {
        
        let field = UITextField(frame: .zero)
        
        if text != nil { field.text = text }
        if placeholder != nil { field.placeholder = placeholder }
        if capitalized == true { field.autocapitalizationType = .sentences }
        if keyboard != nil { field.keyboardType = keyboard! }
        
        field.textColor = CustomColor.text
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.sizeToFit()
        return field
        
    }
    
}
