//
//  RegistrationCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import UIKit

protocol RegistrationCoordinatorProtocol: Coordinator {
}

class RegistrationCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension RegistrationCoordinator: RegistrationCoordinatorProtocol {
    func start() {
        let controller = RegistrationViewController()
        controller.viewModel = RegistrationViewModel()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
