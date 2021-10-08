//
//  MainMenuElementCell.swift
//  wheels_Andrew
//
//  Created by Andrew on 16.07.2021.
//

import UIKit

class MainMenuElementCell: UICollectionViewCell {
    @IBOutlet var elementLabel: UILabel!
    @IBOutlet var elementIcon: UIImageView!
    @IBOutlet weak var container: UIView!
    
    static let reuseIdentifier = "MainMenuElementCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        elementLabel.font = .appFontSemiBold(size: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = frame.height / 4
        container.layer.cornerRadius = cornerRadius
        applyDropShadow(cornerRadius: cornerRadius)
    }
    
    func configure(with element: MenuElement) {
        elementLabel.text = element.name
        elementIcon.image = element.icon
    }
}
