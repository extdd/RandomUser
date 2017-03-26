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

    // UI controls
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: CustomImage.userDefaultPictureName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameHeader: UILabel = UILabel.create(text: "Name:", type: .header)
    let genderHeader: UILabel = UILabel.create(text: "Gender:", type: .header)
    
    var emailHeader: UILabel?
    var phoneHeader: UILabel?
    
    var nameValue: UILabel?
    var genderValue: UILabel?
    var emailValue: UILabel?
    var phoneValue: UILabel?
    
    var firstNameInput: UITextField?
    var lastNameInput: UITextField?
    var emailInput: UITextField?
    var phoneInput: UITextField?

    var emailValidationInfo: UILabel?
    var phoneValidationInfo: UILabel?

    var genderPickerView: UIPickerView?
    var historyButton: UIButton?
    
    // misc
    
    var didSetupConstraints: Bool = false
    
    fileprivate let userDefaultPicture: UIImage? = UIImage(named: CustomImage.userDefaultPictureName)
    fileprivate var constantSubviews: [UIView] = [] // always visible subviews (non-optional picture & headers) in both display modes (show / edit)

    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
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
        
    }
    
    fileprivate func initUI() {
        
        constantSubviews = [pictureImageView, nameHeader, genderHeader]
        self.addSubviews(constantSubviews)
        self.layoutMargins = UIEdgeInsets(all: Layout.margin)
        
    }
    
    // MARK: - CLEAR UI
    
    fileprivate func clearUI() {
        
        // removing non-constant (optional) subviews
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
