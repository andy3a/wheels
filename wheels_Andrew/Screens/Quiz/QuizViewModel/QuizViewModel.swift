//
//  QuizViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 29.07.21.
//

import Foundation
import UIKit
import Combine

class QuizViewModel {
    let ruleUnitType: RuleUnitType!
    var selectedItem = 0
    var topic: Int?
    var questionsArray: [Question]!
    var testMode: TestMode?
    var userAnswers: [UserAnswers] = []
    var duration: Int?
    
    private var uploadResultSubscription: AnyCancellable?
    private var fetchRandomQuestionsSubscription: AnyCancellable?
    private var fetchControlSectionSubscription: AnyCancellable?
    private var fetchRandomControlSectionSubscription: AnyCancellable?
    private var fetchPesonalizedQuestionsSubscription: AnyCancellable?
    private var loadResults: AnyCancellable?
    private var reloadSubject = PassthroughSubject<Void, Never>()
    var reloadPublisher: AnyPublisher<Void, Never> {
        reloadSubject.eraseToAnyPublisher()
    }
    
    init(
        ruleUnitType: RuleUnitType,
        questions: [Question]? = [],
        selectedItem: Int? = 0,
        testMode: TestMode? = nil,
        topic: Int? = nil
    ) {
        self.ruleUnitType = ruleUnitType
        self.questionsArray = questions!
        self.selectedItem = selectedItem!
        if let testMode = testMode {
            self.testMode = testMode
        }
        if let topic = topic {
            self.topic = topic
        }
    }
    
    func fetchRandomQuestions() {
        fetchRandomQuestionsSubscription = QuestionStorage.shared.randomTrainingQuestionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { questions in
                self.questionsArray = questions
                self.reloadSubject.send()
            }
    }
    
    func fetchControlSection(topic: Int) {
        fetchControlSectionSubscription = QuestionStorage.shared.getControlByTopic(topic: topic)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { questions in
                self.questionsArray = questions
                self.reloadSubject.send()
            }
    }
    
    func fetchRandomControlSection() {
        fetchRandomControlSectionSubscription = QuestionStorage.shared.randomControlQuestionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { questions in
                self.questionsArray = questions
                self.reloadSubject.send()
            }
    }
    
    func fetchPesonalizedQuestions() {
        fetchPesonalizedQuestionsSubscription = QuestionStorage.shared.personalizedQuestionPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { questions in
                self.questionsArray = questions
                self.reloadSubject.send()
            }
    }
    
    func saveAnswer(questionIndex: Int, answerIndex: Int) {
        let result = UserAnswers(
            answerId: questionsArray[questionIndex].answers[answerIndex].id,
            questionId: questionsArray[questionIndex].id
        )
        userAnswers.append(result)
    }
    
    func uploadControlResults() {
        let controlResults = ControlResults(durationInSeconds: duration!, userAnswers: userAnswers)
        guard UserManagementStorage.shared.oAuthCredentials?.isLoggedIn == true else {return}
        ControlResultsStorage.shared.uploadResults(results: controlResults)
    }
}
