//
//  LoginViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 10.08.21.
//

import Foundation
import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var enterButton: LoadingButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottonContainerConstraint: NSLayoutConstraint!
    
    var viewModel: LoginViewModel!
    var coordinator: LoginCoordinatorProtocol!
    private var successSubscription: AnyCancellable?
    private var failedSubscription: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarVisible(animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUploginContainerView()
    }
    
    @IBAction func loginButtonPressed(_ sender: LoadingButton) {
        view.endEditing(true)
        // force-cast because button is disabled when textFields are empty
        viewModel.loginUser(username: nameTextField.text!, password: passwordTextField.text!)
        enterButton.showLoading()
        
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        coordinator.coordinateToRegistration()
    }
}

// MARK: SetUp
extension LoginViewController {
    
    private func setUp() {
        setUpEnterButton()
        setUpLoginSubscription()
    }
    
    private func makeNavigationBarVisible(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        title = "Вход"
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setUploginContainerView() {
        let cornerRadius = loginContainerView.frame.height / 10
        loginContainerView.layer.cornerRadius = cornerRadius
        loginContainerView.applyDropShadow(cornerRadius: cornerRadius)
    }
    
    private func setUpEnterButton() {
        enterButton.layer.cornerRadius = enterButton.frame.height / 4
        enterButton.backgroundColor = .systemGray
        enterButton.isEnabled = false
    }
    
    private func setUpLoginSubscription() {
        failedSubscription = viewModel.showAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                guard let response = self.viewModel.response else {return}
                self.showAlert(text: response)
                self.enterButton.hideLoading()
            }
        
        successSubscription = viewModel.loggedInSubjectPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.enterButton.hideLoading()
                guard let username = UserManagementStorage.shared.loginData?.username else {return}
                self.coordinator.coordinateToUserMenu(username: username)
            }
    }
}

// MARK: LifeCycleFunctions
extension LoginViewController: UITextFieldDelegate {
    
    private func showAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !nameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            enterButton.backgroundColor = .systemTeal
            enterButton.isEnabled = true
        } else {
            enterButton.backgroundColor = .systemGray
            enterButton.isEnabled = false
        }
    }
}
