//
//  RegistrationViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: RegistrationViewModel!
    var coordinator: RegistrationCoordinatorProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarVisible(animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpContainerView()
    }
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        viewModel.registerUser(
            email: emailTextField.text!,
            phone: phoneNumberTextField.text!,
            name: nameTextField.text!,
            password: passwordTextField.text!
        )
    }
}

extension RegistrationViewController {
    
    private func SetUp() {
        setUpEnterButton()
    }
    
    private func makeNavigationBarVisible(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        title = "Регистрация"
    }
    
    private func setUpContainerView() {
        let cornerRadius = containerView.frame.height / 10
        containerView.layer.cornerRadius = cornerRadius
        containerView.applyDropShadow(cornerRadius: cornerRadius)
    }
    
    private func setUpEnterButton() {
        registrationButton.layer.cornerRadius = registrationButton.frame.height / 4
        registrationButton.backgroundColor = .systemGray
        registrationButton.isEnabled = false
        
    }
}
// MARK: LifeCycleFunctions
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !emailTextField.text!.isEmpty,
           !phoneNumberTextField.text!.isEmpty,
           !nameTextField.text!.isEmpty,
           !passwordTextField.text!.isEmpty {
            registrationButton.backgroundColor = .systemTeal
            registrationButton.isEnabled = true
        } else {
            registrationButton.backgroundColor = .systemGray
            registrationButton.isEnabled = false
        }
    }
}
