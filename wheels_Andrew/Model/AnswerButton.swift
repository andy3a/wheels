//
//  AnswerButton.swift
//  wheels_Andrew
//
//  Created by Andrew on 30.07.21.
//

import Foundation
import UIKit
import TinyConstraints

class AnswerButton: UIButton {
    var correctAnswerIndicator: Bool!
    var label: UILabel!
    var isPressed = false
    
    func setUpLabel(text: String?) {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        self.addSubview(label)
        label.edgesToSuperview(insets: .horizontal(10) + .vertical(5))
        self.label = label
    }
}
