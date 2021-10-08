//
//  RuleUnitManager.swift
//  wheels_Andrew
//
//  Created by Andrew_Alekseyuk on 23.08.21.
//

import Foundation
import Combine
import Alamofire

protocol RuleUnitManagerProtocol {
    var chapterPublisher: AnyPublisher<[RuleUnitItem], AFError> { get }
    var topicPublisher: AnyPublisher<[RuleUnitItem], AFError> { get }
}

class RuleUnitManager: RuleUnitManagerProtocol {
   
    var chapterPublisher: AnyPublisher<[RuleUnitItem], AFError> {
        if let chapterCache = CacheManager.chapterCache["chapters"] {
            return Just(chapterCache)
                .setFailureType(to: AFError.self)
                .eraseToAnyPublisher()
        } else {
            return Networking.chapterPublisher
                .handleEvents(receiveOutput: { chapters in
                    let cache = Cache<String, Any>()
                    cache["chapters"] = chapters
                    CacheManager.chapterCache["chapters"] = chapters
                })
                .eraseToAnyPublisher()
        }
    }
    
    var topicPublisher: AnyPublisher<[RuleUnitItem], AFError> {
        if let topicCache = CacheManager.topicCache["topics"] {
            return Just(topicCache)
                .setFailureType(to: AFError.self)
                .eraseToAnyPublisher()
        } else {
            return Networking.topicPublisher
                .handleEvents(receiveOutput: { topics in
                    let cache = Cache<String, Any>()
                    cache["topics"] = topics
                    CacheManager.topicCache["topics"] = topics
                })
                .eraseToAnyPublisher()
        }
    }
    
}
