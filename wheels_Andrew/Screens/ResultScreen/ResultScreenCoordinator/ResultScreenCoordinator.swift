//
//  ResultScreenCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 6.08.21.
//

import Foundation
import UIKit

protocol ResultScreenCoordinatorProtocol: Coordinator {
    func returnToMainScreen()
}

class ResultScreenCoordinator {
    let navigationController: UINavigationController
    let result: String
    
    init(navigationController: UINavigationController, result: String) {
        self.navigationController = navigationController
        self.result = result
        
    }
}

extension ResultScreenCoordinator: ResultScreenCoordinatorProtocol {
    func start() {
        let controller = ResultScreenViewController()
        controller.viewModel = ResultScreenViewModel(result: result)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: false)
    }
    
    func returnToMainScreen() {
        navigationController.popToRootViewController(animated: true)
    }
}
