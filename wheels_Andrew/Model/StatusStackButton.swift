//
//  StatusStackButton.swift
//  wheels_Andrew
//
//  Created by Andrew on 4.08.21.
//

import Foundation
import UIKit
import TinyConstraints

class StatusStackButton: UIButton {
    let color = UIColor.systemGray
    var isAnswered = false
    var isCorrectlyAnswered: Bool?
    
    var buttonIndex: Int?
    var label: UILabel?
    
    func setUpLabel(text: String?) {
        let label = UILabel()
        self.addSubview(label)
        label.edgesToSuperview()
        label.textAlignment = .center
        label.text = text
        label.numberOfLines = 1
        self.label = label
    }
    
    func isChoosen(isChoosen: Bool) {
        if isChoosen {
            self.layer.borderWidth = 3
            self.layer.borderColor = color.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
    
    func isCorrectAnswer(answer: Bool, controlMode: ControlMode) {
        switch controlMode {
        case .open:
            self.backgroundColor = answer ? .systemGreen : .systemRed
        case .closed:
            self.backgroundColor = .systemTeal
        }
        self.isCorrectlyAnswered = answer
    }
}
