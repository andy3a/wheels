//
//  HeaderView.swift
//  wheels_Andrew
//
//  Created by Andrew on 19.07.2021.
//

import UIKit

class HeaderView: UICollectionReusableView {
    @IBOutlet var headerLabel: UILabel!
    
    static let reuseIdentifier = "HeaderView"
    
    func configure(with header: String) {
        headerLabel.text = header
    }
}
