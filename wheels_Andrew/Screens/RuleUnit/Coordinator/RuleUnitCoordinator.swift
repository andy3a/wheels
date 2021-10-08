//
//  RuleUnitCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 20.07.21.
//

import UIKit

protocol RuleUnitCoordinatorProtocol: Coordinator {
    func coordinateToChooseQuestion(testMode: TestMode, id: Int, header: String)
    func goToControlViewController(ruleUnitType: RuleUnitType, testMode: TestMode, topic: Int)
}

class RuleUnitCoordinator {
    let navigationController: UINavigationController
    let ruleUnitType: RuleUnitType
    let testMode: TestMode
    
    init(navigationController: UINavigationController, ruleUnitType: RuleUnitType, testMode: TestMode) {
        self.navigationController = navigationController
        self.ruleUnitType = ruleUnitType
        self.testMode = testMode
    }
}

extension RuleUnitCoordinator: RuleUnitCoordinatorProtocol {
    func coordinateToChooseQuestion(testMode: TestMode, id: Int, header: String) {
        let coordinator = ChooseQuestionCoordinator(
            navigationController: navigationController,
            testMode: testMode,
            id: id,
            header: header
        )
        coordinate(to: coordinator)
    }
    
    func goToControlViewController(ruleUnitType: RuleUnitType, testMode: TestMode, topic: Int) {
        let coordinator = QuizCoordinator(
            navigationController: navigationController,
            ruleUnitType: ruleUnitType,
            testMode: testMode,
            topic: topic
        )
        coordinate(to: coordinator)
    }
    
    func start() {
        let ruleUnit = RuleUnitFactory.ruleUnitViewContoller(
            ruleUnitType: ruleUnitType,
            testMode: testMode
        )
        ruleUnit.coordinator = self
        navigationController.pushViewController(ruleUnit, animated: true)
    }
}
