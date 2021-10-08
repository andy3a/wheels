//
//  UIView+applyDropShadow.swift
//  wheels_Andrew
//
//  Created by Andrew on 19.07.2021.
//

import UIKit

extension UIView {
    func applyDropShadow(cornerRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
    }
}
