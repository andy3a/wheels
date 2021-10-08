//
//  QuestionStorage.swift
//  wheels_Andrew
//
//  Created by Andrew_Alekseyuk on 23.08.21.
//

import Foundation
import Combine
import Alamofire

class QuestionStorage {
    
    static let shared = QuestionStorage()
    
    private init() { }

    func questionSectionPublisher(
        chooseQuestionRequest: ChooseQuestionRequest
    ) -> AnyPublisher<[Question], AFError> {
        Networking.questions(chooseQuestionRequest: chooseQuestionRequest)
            .eraseToAnyPublisher()
    }
    
    var randomTrainingQuestionsPublisher: AnyPublisher<[Question], AFError> {
        Networking.randomTrainingQuestions
            .eraseToAnyPublisher()
    }
    
    func getControlByTopic(
        topic: Int
    ) -> AnyPublisher<[Question], AFError> {
        Networking.getControlByTopic(topic: topic)
            .map { questionDictionary in
                let questionArray = questionDictionary.questions
                return questionArray
                
            }
            .eraseToAnyPublisher()
    }
    
    var randomControlQuestionsPublisher: AnyPublisher<[Question], AFError> {
        Networking.randomControlQuestions
            .map { questionDictionary in
                let questionArray = questionDictionary.questions
                return questionArray
                
            }
            .eraseToAnyPublisher()
    }
    
    var personalizedQuestionPublisher: AnyPublisher<[Question], AFError> {
        Networking.personalizedTraining
            .map { result in
                let questionArray = result.questions
                return questionArray
            }
            .eraseToAnyPublisher()
    }
}
