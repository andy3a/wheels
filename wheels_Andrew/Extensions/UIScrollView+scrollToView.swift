//
//  UIScrollView+scrollToView.swift
//  wheels_Andrew
//
//  Created by Andrew on 3.08.21.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToView(_ view: UIView, animated: Bool) {
        guard let superview = view.superview else { return }
        let childOrigin = superview.convert(view.frame.origin, to: self)
        setContentOffset(childOrigin, animated: true)
    }
}
