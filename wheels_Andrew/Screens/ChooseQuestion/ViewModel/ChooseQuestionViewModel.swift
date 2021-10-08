//
//  ChooseQuestionViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import Foundation
import UIKit
import Combine

class ChooseQuestionViewModel {
    var questions: [Question]?
    let testMode: TestMode
    let id: Int
    let header: String
    
    private let reloadSubject = PassthroughSubject<Void, Never>()
    var reloadPublisher: AnyPublisher<Void, Never> {
        reloadSubject.eraseToAnyPublisher()
    }
    private var fetchDataSubscription: AnyCancellable?
    
    init(testMode: TestMode, id: Int, header: String) {
        self.testMode = testMode
        self.id = id
        self.header = header
    }
    
    func fetchData() {
        let request = ChooseQuestionRequest(id: self.id, testMode: self.testMode)
        fetchDataSubscription = QuestionStorage.shared.questionSectionPublisher(
            chooseQuestionRequest: request
        )
        .sink { _ in
        } receiveValue: { [weak self] questions in
            guard let self = self else { return }
            self.questions = questions
            self.reloadSubject.send()
        }
    }
}
