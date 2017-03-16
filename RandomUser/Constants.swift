//
//  Constants.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import UIKit

// LAYOUT

struct Layout {
    
    static let margin: CGFloat = 16
    static let marginMedium: CGFloat = 12
    static let marginSmall: CGFloat = 8
    static let marginExtraSmall: CGFloat = 4
    static let keyboardTopInset: CGFloat = 32 // extra space between keyboard & selected textfield
    static let buttonHeight: CGFloat = 44
    
}

// FONT

struct CustomFont {
    
    static let text = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
    static let header = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
    static let detail = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
    static let date = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
    static let symbol = UIFont.systemFont(ofSize: 26, weight: UIFontWeightRegular)
    static let validationInfo = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
    
}

// COLOR

struct CustomColor {

    static let defaultTint = UIColor(hex: 0x269fd7)
    static let navigationTint = UIColor(hex: 0x41e2fa)
    static let text = UIColor(hex: 0x2d2b37)
    static let dark = UIColor(hex: 0x2d2b37)
    static let light = UIColor(hex: 0xf8f7f7)
    static let gray = UIColor(hex: 0x595959)
    static let red = UIColor(hex: 0xe3202b)

}

// IMAGE

struct CustomImage {
    
    static let userDefaultThumbnailName: String = "UserDefaultThumbnail"
    static let userDefaultPictureName: String = "UserDefaultLarge"
    
}

