//
//  MyColors.swift
//  Cooking
//
// Created by . on 25/09/24.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}

enum MyColors: Int, CaseIterable {
    case orange = 0xEF7D44
    case black = 0x0D0D0D
    case lightBlue = 0x99DDFF
    case lightGreen = 0xC0EB65
    case white = 0xFFFFFF
    case gray = 0x838A8C
    case secondaryText = 0x262C3A
    case yellow = 0xFEC700
    case purple = 0x626DB3
    case tabBar = 0x1F2644
    case green = 0x479C7D
    case pageControl = 0xB3B3B3
    case mainBG = 0x333333
    case cellBG = 0x05140C
    case bankrollTint = 0x05140CB2
    case blue = 0x001931
    case background = 0x262626
    case darkGreen = 0x4E5C5F
    case darkBlue = 0x170F46
    case tabColor = 0x1A1A1A
    case darkGray = 0x404040
    case red = 0xF81616
    case timerBtnBg = 0x656767
    case tintColor = 0xCC5127
    case accent = 0x7EB8F8
    case greyLight = 0xF5F5F5
    case darkRed = 0xA60104
    case violate = 0xCA03A4
    case centerTextColor = 0x7E1E1F
    case pinkish = 0xCF0150

    var color: UIColor {
        
        switch self {
        default:
            return UIColor.init(hex: rawValue)
        }
        
    }
}
