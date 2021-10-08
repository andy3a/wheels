//
//  MainMenuCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 20.07.21.
//

import UIKit

protocol MainMenuCoordinatorProtocol: Coordinator {
    func coordinateToRuleUnit(ruleUnitType: RuleUnitType, testMode: TestMode)
    func coordinateToQuiz(ruleUnitType: RuleUnitType, testMode: TestMode)
    func coordinateToUserProfile()
}

class MainMenuCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension MainMenuCoordinator: MainMenuCoordinatorProtocol {
    func start() {
        let mainMenu = MainMenuViewController()
        mainMenu.coordinator = self
        navigationController.pushViewController(mainMenu, animated: true)
    }
    // MARK: - Flow Methods
    func coordinateToRuleUnit(ruleUnitType: RuleUnitType, testMode: TestMode) {
        let coordinator = RuleUnitCoordinator(
            navigationController: navigationController,
            ruleUnitType: ruleUnitType,
            testMode: testMode
        )
        coordinate(to: coordinator)
    }
    
    func coordinateToQuiz(ruleUnitType: RuleUnitType, testMode: TestMode) {
        let coordinator = QuizCoordinator(
            navigationController: navigationController,
            ruleUnitType: ruleUnitType,
            testMode: testMode
        )
        coordinate(to: coordinator)
    }
    
    func coordinateToUserProfile() {
        switch UserManagementStorage.shared.oAuthCredentials?.isLoggedIn {
        case .some(true):
            let coordinator = UserCoordinator(
                navigationController: navigationController,
                username: UserManagementStorage.shared.oAuthCredentials!.username
            )
            coordinate(to: coordinator)
        case .some(false), .none:
            let coordinator = LoginCoordinator(
                navigationController: navigationController
            )
            coordinate(to: coordinator)
        }
    }
}
