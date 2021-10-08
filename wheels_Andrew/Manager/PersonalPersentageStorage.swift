//
//  PersonalPersentageStorage.swift
//  wheels_Andrew
//
//  Created by Andrew_Alekseyuk on 23.08.21.
//

import Foundation
import Combine
import Alamofire

class PersonalPersentageStorage {
    static let shared = PersonalPersentageStorage()
    
    private init() { }
    
    private var getPersonalPersentageSubscription: AnyCancellable?

    private var personalPersentageSubject = PassthroughSubject<Double, AFError>()
    var personalPersentagePublisher: AnyPublisher<Double, AFError> {
        personalPersentageSubject.eraseToAnyPublisher()
    }

   func fetchPersentage() {
        getPersonalPersentageSubscription = Networking.getPersonalPersentage
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { percentage in
                self.personalPersentageSubject.send(percentage)
            })
    }
}
