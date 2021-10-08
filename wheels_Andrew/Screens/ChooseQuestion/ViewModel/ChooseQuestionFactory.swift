//
//  ChooseQuestionFactory.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import Foundation
import UIKit

struct ChooseQuestionFactory {
    static func chooseQuestionViewContoller(
        testMode: TestMode,
        id: Int,
        header: String
    ) -> ChooseQuestionViewController {
        let viewModel = ChooseQuestionViewModel(testMode: testMode, id: id, header: header)
        let controller = ChooseQuestionViewController()
        controller.viewModel = viewModel
        return controller
    }
}
