//
//  LoginCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 10.08.21.
//

import Foundation
import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func coordinateToRegistration()
    func coordinateToUserMenu(username: String)
}

class LoginCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension LoginCoordinator: LoginCoordinatorProtocol {
    func start() {
        let controller = LoginViewController()
        controller.viewModel = LoginViewModel()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func coordinateToRegistration() {
        let coordinator = RegistrationCoordinator(
            navigationController: navigationController
        )
        coordinate(to: coordinator)
    }
    
    func coordinateToUserMenu(username: String) {
        let coordinator = UserCoordinator(
            navigationController: navigationController,
            username: username
        )
        coordinate(to: coordinator)
    }
}
