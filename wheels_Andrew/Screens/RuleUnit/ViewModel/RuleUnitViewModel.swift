//
//  RuleUnitViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 22.07.21.
//

import Foundation
import Combine

class RuleUnitViewModel {
    
    let navigationBarHeader: String
    let currentRuleUnitType: RuleUnitType
    let currentTestMode: TestMode
    private var fetchDataSubscription: AnyCancellable?
    private var fetchControlSectionSubscription: AnyCancellable?
    var elements: [RuleUnitItem] = []
    private let reloadSubject = PassthroughSubject<Void, Never>()
        var reloadPublisher: AnyPublisher<Void, Never> {
            reloadSubject.eraseToAnyPublisher()
        }
    private let loadCoordinatorSubject = PassthroughSubject<Void, Never>()
        var loadCoordinatorPublisher: AnyPublisher<Void, Never> {
            loadCoordinatorSubject.eraseToAnyPublisher()
        }
    var questions: [Question]!
    
    let storage: RuleUnitManagerProtocol
    
    init(ruleUnitType: RuleUnitType, testMode: TestMode) {
        currentRuleUnitType = ruleUnitType
        currentTestMode = testMode
        navigationBarHeader = testMode.title
        storage = RuleUnitManager()
    }

    func fetchUnitData() {
        switch currentTestMode {
        case .chapters:
            fetchDataSubscription = storage.chapterPublisher
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { [weak self] chapters in
                    guard let self = self else { return }
                    self.mapRecievedDataToUnit(data: chapters)
                }
        case .topics:
            fetchDataSubscription = storage.topicPublisher
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { [weak self] topics in
                    guard let self = self else { return }
                    self.mapRecievedDataToUnit(data: topics)

                }
        case .random:
            return
        case .personalized:
            return
        }
    }

    func mapRecievedDataToUnit(data: [RuleUnitItem]) {
        self.elements = data
        self.reloadSubject.send()
    }
}
