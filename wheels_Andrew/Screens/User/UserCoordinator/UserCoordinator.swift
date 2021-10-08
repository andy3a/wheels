//
//  UserCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import UIKit

protocol UserCoordinatorProtocol: Coordinator {
    func returnToMainScreen()
    func coordinateToQuiz(ruleUnitType: RuleUnitType, testMode: TestMode)
}

class UserCoordinator {
    let navigationController: UINavigationController
    let username: String

    init(navigationController: UINavigationController, username: String) {
        self.navigationController = navigationController
        self.username = username
    }
}

extension UserCoordinator: UserCoordinatorProtocol {
    func start() {
        let controller = UserViewController()
        controller.viewModel = UserViewModel(username: username)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func returnToMainScreen() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func coordinateToQuiz(ruleUnitType: RuleUnitType, testMode: TestMode) {
        let coordinator = QuizCoordinator(
            navigationController: navigationController,
            ruleUnitType: ruleUnitType,
            testMode: testMode
        )
        coordinate(to: coordinator)
    }
}
