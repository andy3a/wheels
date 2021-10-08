//
//  TrainingCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 28.07.21.
//

import Foundation
import UIKit

protocol QuizCoordinatorProtocol: Coordinator {
    func coordinateToResultScreen(result: String) 
}

class QuizCoordinator {
    let navigationController: UINavigationController
    let ruleUnitType: RuleUnitType
    let testMode: TestMode
    let topic: Int

    init(navigationController: UINavigationController, ruleUnitType: RuleUnitType, testMode: TestMode, topic: Int = 0) {
        self.navigationController = navigationController
        self.ruleUnitType = ruleUnitType
        self.testMode = testMode
        self.topic = topic
    }
}

extension QuizCoordinator: QuizCoordinatorProtocol {
    func coordinateToResultScreen(result: String) {
        let resultScreen = ResultScreenCoordinator(navigationController: navigationController, result: result)
        coordinate(to: resultScreen)
    }
    
    func start() {
        switch ruleUnitType {
        case .control:
            let controller = ControlViewController()
            controller.coordinator = self
            let viewModel = QuizViewModel(ruleUnitType: ruleUnitType, testMode: testMode, topic: topic)
            controller.viewModel = viewModel
            navigationController.pushViewController(controller, animated: true)
        case .training:
            let controller = TrainingViewController()
            controller.coordinator = self
            let viewModel = QuizViewModel(ruleUnitType: ruleUnitType, testMode: testMode)
            controller.viewModel = viewModel
            navigationController.pushViewController(controller, animated: true)
        }
      }
    // MARK: - Flow Methods
    
}
