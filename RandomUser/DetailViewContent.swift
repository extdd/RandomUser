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
    
    // collection for an always visible subviews (picture & headers) in both display modes (show / edit)
    
    var constantSubviews: [UIView] = []
    
    // internal UI controls
    
    lazy var pictureImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(image: self.userDefaultPicture)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView }()
    
    lazy var genderPickerView: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.backgroundColor = .white
        return picker }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Change history", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: CustomColor.violet)
        return button }()
    
    lazy var firstNameInput: UITextField = { UITextField.create(placeholder: "First name", capitalized: true) }()
    lazy var lastNameInput: UITextField = { UITextField.create(placeholder: "Last name", capitalized: true) }()
    lazy var emailInput: UITextField = { UITextField.create(placeholder: "E-mail address", capitalized: true, keyboard: .emailAddress) }()
    lazy var phoneInput: UITextField = { UITextField.create(placeholder: "Phone number", capitalized: true, keyboard: .namePhonePad) }()
    
    // private UI controls & views
    
    fileprivate lazy var nameHeader: UILabel = { UILabel.create(text: "Name:", header: true) }()
    fileprivate lazy var genderHeader: UILabel = { UILabel.create(text: "Gender:", header: true) }()
    fileprivate lazy var emailHeader: UILabel = { UILabel.create(text: "E-mail:", header: true) }()
    fileprivate lazy var phoneHeader: UILabel = { UILabel.create(text: "Phone:", header: true) }()
    
    fileprivate lazy var nameValue: UILabel = { UILabel.create() }()
    fileprivate lazy var genderValue: UILabel = { UILabel.create() }()
    fileprivate lazy var emailValue: UILabel = { UILabel.create() }()
    fileprivate lazy var phoneValue: UILabel = { UILabel.create() }()
    
    fileprivate var userDefaultPicture: UIImage? {
        return UIImage(named: "UserDefaultLarge")
    }
    
    // MARK: - INIT
    
    func initUI() {
        
        self.layoutMargins = UIEdgeInsets(all: Layout.margin)
        constantSubviews = [pictureImageView, nameHeader, genderHeader, emailHeader, phoneHeader]
        self.addSubviews(constantSubviews)
        
    }
    
    // MARK: - UPDATE UI
    
    func update(forUser user: User, displayMode: DisplayMode) {
        
        clear()
        
        if let pictureURL = user.pictureURL {
            pictureImageView.sd_setImage(with: URL(string: pictureURL), placeholderImage: userDefaultPicture)
        }
        
        switch (displayMode) {
        case .show:

            nameValue.text = user.fullName
            genderValue.text = user.gender
            emailValue.text = user.email
            phoneValue.text = user.phone
            self.addSubviews([nameValue, genderValue, emailValue, phoneValue, historyButton])
            
        case .add:
            firstNameInput.becomeFirstResponder()
            fallthrough
            
        case .edit:
            
            firstNameInput.text = user.firstName
            lastNameInput.text = user.lastName
            emailInput.text = user.email
            phoneInput.text = user.phone
            genderPickerView.selectRow(Gender.fromString(string: user.gender).hashValue, inComponent: 0, animated: false)
            self.addSubviews([firstNameInput, lastNameInput, emailInput, phoneInput, genderPickerView])
            
        }
        
        updateConstraints(displayMode: displayMode)
        
    }
    
    // MARK: - CONSTRAINTS
    
    func updateConstraints(displayMode: DisplayMode? = .show) {

        // picture
        pictureImageView.snp.remakeConstraints { make in
            make.top.equalTo(snp.topMargin)
            make.left.equalTo(snp.leftMargin)
            make.width.height.equalTo(snp.width).multipliedBy(0.3) }
        
        // name header
        nameHeader.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(Layout.margin)
            make.left.equalTo(pictureImageView.snp.right).offset(Layout.margin)
            make.right.equalTo(snp.rightMargin) }
        
        // gender header
        genderHeader.snp.remakeConstraints { make in
            make.top.equalTo(pictureImageView.snp.bottom).offset(Layout.margin)
            make.left.equalTo(snp.leftMargin)
            make.right.equalTo(snp.rightMargin) }

        switch (displayMode!) {
        case .show:
            
            // name
            nameValue.snp.remakeConstraints { make in
                make.top.equalTo(nameHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(nameHeader) }
            
            // gender
            genderValue.snp.remakeConstraints { make in
                make.top.equalTo(genderHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(genderHeader) }
            
            // contact
            emailHeader.snp.remakeConstraints { make in
                make.top.equalTo(genderValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderValue) }
            
            emailValue.snp.remakeConstraints { make in
                make.top.equalTo(emailHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(emailHeader) }
            
            phoneHeader.snp.remakeConstraints { make in
                make.top.equalTo(emailValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader) }
            
            phoneValue.snp.remakeConstraints { make in
                make.top.equalTo(phoneHeader.snp.bottom).offset(Layout.marginExtraSmall)
                make.left.right.equalTo(phoneHeader) }
            
            // history button
            historyButton.snp.remakeConstraints { make in
                make.top.equalTo(phoneValue.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(phoneHeader)
                make.height.equalTo(40) }
            
        case .edit, .add:
            
            // name
            firstNameInput.snp.remakeConstraints { make in
                make.top.equalTo(nameHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(nameHeader) }
            
            lastNameInput.snp.remakeConstraints { make in
                make.top.equalTo(firstNameInput.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(nameHeader) }
            
            // gender
            genderPickerView.snp.remakeConstraints { make in
                make.top.equalTo(genderHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalToSuperview()
                make.height.equalTo(100) }
            
            // contact
            emailHeader.snp.remakeConstraints { make in
                make.top.equalTo(genderPickerView.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader) }
            
            emailInput.snp.remakeConstraints { make in
                make.top.equalTo(emailHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(emailHeader) }
            
            phoneHeader.snp.remakeConstraints { make in
                make.top.equalTo(emailInput.snp.bottom).offset(Layout.margin)
                make.left.right.equalTo(genderHeader) }
            
            phoneInput.snp.remakeConstraints { make in
                make.top.equalTo(phoneHeader.snp.bottom).offset(Layout.marginSmall)
                make.left.right.equalTo(phoneHeader) }
            
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
        
    }
    
}

// MARK: - UI CONTROLS EXTENSIONS

fileprivate extension UILabel {
    
    class func create(text: String? = nil, header: Bool = false) -> UILabel {
        
        let label = UILabel(frame: .zero)
        if text != nil { label.text = text }
        if header { label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: UIFontWeightSemibold) }
        label.textColor = UIColor(hex: CustomColor.text)
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
        field.textColor = UIColor(hex: CustomColor.text)
        field.borderStyle = .roundedRect
        field.sizeToFit()
        return field
        
    }
    
}
