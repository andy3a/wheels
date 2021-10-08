//
//  UILabel+applyFont.swift
//  wheels_Andrew
//
//  Created by Andrew on 23.07.21.
//

import Foundation
import UIKit

extension UIFont {
    static func appFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Gill Sans", size: size)
    }
    
    static func appFontSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "GillSans-SemiBold", size: size)
    }
}
