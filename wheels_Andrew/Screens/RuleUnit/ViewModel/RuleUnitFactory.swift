//
//  RuleUnitFactory.swift
//  wheels_Andrew
//
//  Created by Andrew on 22.07.21.
//

import Foundation

struct RuleUnitFactory {
    static func ruleUnitViewContoller (ruleUnitType: RuleUnitType, testMode: TestMode) -> RuleUnitViewController {
        let viewModel = RuleUnitViewModel(ruleUnitType: ruleUnitType, testMode: testMode)
        let controller = RuleUnitViewController()
        controller.viewModel = viewModel
        return controller
    }
}
