//
//  Networking.swift
//  wheels_Andrew
//
//  Created by Andrew on 23.07.21.
//

import Foundation
import Alamofire
import Combine

class Networking {
    private static let baseURL = URL(string: "https://kolesa-app.herokuapp.com")!
    static var chapterPublisher: AnyPublisher<[RuleUnitItem], AFError> {
        AF.request(
            baseURL.appendingPathComponent("/chapters")
        )
        .validate()
        .publishDecodable(type: [RuleUnitItem].self)
        .value()
        .eraseToAnyPublisher()
    }
    static var topicPublisher: AnyPublisher<[RuleUnitItem], AFError> {
        AF.request(
            baseURL.appendingPathComponent("/topics")
        )
        .validate()
        .publishDecodable(type: [RuleUnitItem].self)
        .value()
        .eraseToAnyPublisher()
    }
    static func questions(chooseQuestionRequest: ChooseQuestionRequest) -> AnyPublisher<[Question], AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/questions")
                .appendingPathComponent("/\(chooseQuestionRequest.testMode.pathComponent)")
                .appendingPathComponent("/\(chooseQuestionRequest.id)")
        )
        .validate()
        .publishDecodable(type: [Question].self)
        .value()
        .eraseToAnyPublisher()
    }
    
    static var randomTrainingQuestions: AnyPublisher<[Question], AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/questions")
                .appendingPathComponent("/random")
        )
        
        .validate()
        .publishDecodable(type: [Question].self)
        .value()
        .eraseToAnyPublisher()
    }
    
    static func getControlByTopic(topic: Int) -> AnyPublisher<QuestionDictionary, AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/controls")
                .appendingPathComponent("/topic")
                .appendingPathComponent("/\(topic)")
        )
        .validate()
        .publishDecodable(type: QuestionDictionary.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    static var randomControlQuestions: AnyPublisher<QuestionDictionary, AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/controls")
                .appendingPathComponent("/random")
        )
        
        .validate()
        .publishDecodable(type: QuestionDictionary.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    static func uploadResults(results: ControlResults) -> AnyPublisher<Void, AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/controls"),
            
            method: .post,
            
            parameters: results,
            encoder: JSONParameterEncoder.default,
            interceptor: OAuthInterceptor.shared
        )
        .validate()
        .publishData(emptyResponseCodes: [200])
        .value()
        .map { _ in }
        .eraseToAnyPublisher()
    }
    
    static func loginUser(credentials: LoginCredentials) -> AnyPublisher<LoginResponse, AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/auth")
                .appendingPathComponent("/login"),
            method: .post,
            parameters: credentials,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .publishDecodable(type: LoginResponse.self)
        .value()
        .eraseToAnyPublisher()
        
    }
    
    static func loginOutUser(logOutUser: LogOutRequestModel) -> AnyPublisher<Void, AFError> {
        AF.request(
            baseURL
                .appendingPathComponent("/auth")
                .appendingPathComponent("/logout"),
            method: .post,
            parameters: logOutUser,
            encoder: JSONParameterEncoder.default
        )
        .publishData()
        .value()
        .map { _ in
        }
        .eraseToAnyPublisher()
    }
    
    static func registerUser(registerRequest: RegisterRequest) -> AnyPublisher<Void, AFError> {
        AF.request(
            baseURL
                .appendingPathComponent("/auth")
                .appendingPathComponent("/signUp"),
            method: .post,
            parameters: registerRequest,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .publishData()
        .value()
        .map { _ in
        }
        .eraseToAnyPublisher()
    }
    
    static var personalizedTraining: AnyPublisher<PersonalizedQuestions, AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/controls")
                .appendingPathComponent("/personalized"),
            interceptor: OAuthInterceptor.shared
        )
        .validate()
        .publishDecodable(type: PersonalizedQuestions.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    static var getPersonalPersentage: AnyPublisher<Double, AFError> {
        return AF.request(
            baseURL
                .appendingPathComponent("/controls")
                .appendingPathComponent("/percentage"),
            interceptor: OAuthInterceptor.shared
        )
        .validate()
        .publishDecodable(type: Double.self)
        .value()
        .eraseToAnyPublisher()
    }
}
