//
//  RuleUnitCollectionViewCell.swift
//  wheels_Andrew
//
//  Created by Andrew on 22.07.21.
//

import UIKit

class RuleUnitCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    
    static let reuseIdentifier = "RuleUnitCollectionViewCell"
    
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
    
    func configure(with header: String) {
        label.text = header
    }
}
