//
//  ChooseQuestionCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import Foundation
import UIKit

protocol ChooseQuestionCoordinatorProtocol: Coordinator {
    func goToTrainingViewController(questions: [Question], selectedItem: Int, testMode: TestMode)
}

class ChooseQuestionCoordinator {
    let navigationController: UINavigationController
    let testMode: TestMode
    let id: Int
    let header: String
    
    init(
        navigationController: UINavigationController,
        testMode: TestMode,
        id: Int,
        header: String
    ) {
        self.navigationController = navigationController
        self.testMode = testMode
        self.id = id
        self.header = header
    }
}

extension ChooseQuestionCoordinator: ChooseQuestionCoordinatorProtocol {
    func start() {
        let chooseQuestion = ChooseQuestionFactory.chooseQuestionViewContoller(
            testMode: testMode,
            id: id,
            header: header
        )
        chooseQuestion.coordinator = self
        navigationController.pushViewController(chooseQuestion, animated: true)
    }
    // MARK: - Flow Methods
    func goToTrainingViewController(questions: [Question], selectedItem: Int, testMode: TestMode) {
        let viewController = TrainingViewController()
        viewController.currentIndex = selectedItem
        let viewModel = QuizViewModel(
            ruleUnitType: .training,
            questions: questions,
            selectedItem: selectedItem,
            testMode: testMode
        )
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
