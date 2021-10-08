//
//  PersonalButton.swift
//  wheels_Andrew
//
//  Created by Andrew on 21.07.21.
//

import UIKit
import TinyConstraints

// TODO: buttonAnimation

class PersonalButton: UIButton {
    private var gradient: CAGradientLayer!
    var buttonTitle: String!
    var buttonSubTitle: String!
    var isLoggedIn: Bool!
    
    func setUpTitles (title: String, subTitle: String, isLoggedIn: Bool) {
        self.buttonTitle = title
        self.buttonSubTitle = subTitle
        self.isLoggedIn = isLoggedIn
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.layer.sublayers?.forEach { sublayer in
            sublayer.removeFromSuperlayer()
        }
        setUpPersonalButton()
        insertStack()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpPersonalButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpPersonalButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isLoggedIn == true {
            gradient.frame = bounds
            setCornerRadius()
        } else {
            setCornerRadius()
        }
    }
    
    private func setUpPersonalButton() {
        if isLoggedIn == true {
            insertGradient()
        } else {
            self.backgroundColor = .systemGray
        }
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = frame.height / 5
        clipsToBounds = true
    }
    
    private func insertGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 138.0/255.0, green: 157.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor,
                           UIColor(red: 131.0/255.0, green: 182.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }
    
    private func insertStack() {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.isUserInteractionEnabled = false
        labelStack.spacing = 5
        let titleLabel = UILabel()
        titleLabel.text = self.buttonTitle
        titleLabel.textColor = .white
        titleLabel.font = .appFontSemiBold(size: 20)
        labelStack.addArrangedSubview(titleLabel)
        let subTitleLabel = UILabel()
        subTitleLabel.text = self.buttonSubTitle
        subTitleLabel.font = .appFont(size: 15)
        subTitleLabel.textColor = .white
        labelStack.addArrangedSubview(subTitleLabel)
        addSubview(labelStack)
        labelStack.edgesToSuperview(insets: .uniform(20))
    }
}
