//
//  LoadingButton.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import UIKit
import TinyConstraints

class LoadingButton: UIButton {
    private var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator = activityIndicator
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        activityIndicator.horizontalToSuperview()
        activityIndicator.verticalToSuperview()
        
    }
}
