//
//  ResultScreenViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 6.08.21.
//

import Foundation
import UIKit
import Combine

class ResultScreenViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var uploadResultLabel: UILabel!
    @IBOutlet weak var backToMainMenuButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinator: ResultScreenCoordinatorProtocol!
    var viewModel: ResultScreenViewModel!
    
    var subscription: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpStackViewContainer()
        setUpButton()
    }

    @IBAction func backtoMainMenu(_ sender: UIButton) {
        coordinator.returnToMainScreen()
    }
}

extension ResultScreenViewController {
    
    private func setUp() {
        setUpLabel()
        setUpNavigationBar()
        setUpUploadResultLabel()
        setUpButton()
    }
    
    private func setUpLabel() {
        resultLabel.text = viewModel.result
    }
    private func setUpUploadResultLabel() {
       
        uploadResultLabel.textAlignment = .center
        switch UserManagementStorage.shared.oAuthCredentials?.isLoggedIn {
        case nil:
            uploadResultLabel.text = "Залогиньтесь для выгрузки результатов"
            activityIndicator.stopAnimating()
        case .some(true):
            setUpUploadResultSubscription()
        case .some(false):
            uploadResultLabel.text = "Залогиньтесь для выгрузки результатов"
            activityIndicator.stopAnimating()
        }
    }
    
    private func setUpUploadResultSubscription() {
        viewModel.subscribeToUploadResults()
        subscription = viewModel.uploadResulResponsePublisher
            .retry(0)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] resultString in
                guard let self = self else {return}
                if resultString ==  "Выгрузка результатов" {
                    self.uploadResultLabel.text = resultString
                } else {
                    self.uploadResultLabel.text = resultString
                    self.activityIndicator.stopAnimating()
                }
            })
        
    }
    
    private func setUpNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUpButton() {
        backToMainMenuButton.backgroundColor = .systemTeal
        backToMainMenuButton.layer.cornerRadius = backToMainMenuButton.frame.height / 3
        backToMainMenuButton.titleLabel?.textColor = .white
    }
    
    private func setUpStackViewContainer() {
        let cornerRadius = containerView.frame.height / 10
        containerView.layer.cornerRadius = cornerRadius
        containerView.applyDropShadow(cornerRadius: cornerRadius)
    }
}
