//
//  ChooseQuestionCollectionViewCell.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import Foundation
import UIKit

class ChooseQuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var container: UIView!
    
    static let reuseIdentifier = "ChooseQuestionCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        self.label.font = .appFont(size: 17)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = frame.height / 4
        container.layer.cornerRadius = cornerRadius
        applyDropShadow(cornerRadius: cornerRadius)
    }
    
    func configure(questions: [Question], index: Int) {
        label.text = String(questions[index].id)
    }
}
