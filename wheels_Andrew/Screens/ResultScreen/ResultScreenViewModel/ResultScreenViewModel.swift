//
//  ResultScreenViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 6.08.21.
//

import Foundation
import UIKit
import Combine

class ResultScreenViewModel {
    var result: String
    var subscription: AnyCancellable?

    private var uploadResulSubject = PassthroughSubject<String, Error>()
    var uploadResulResponsePublisher: AnyPublisher<String, Error> {
        uploadResulSubject.eraseToAnyPublisher()
    }
    
    init(result: String) {
        self.result = result
        
    }
    
    func subscribeToUploadResults() {
        subscription = ControlResultsStorage.shared.uploadResultsResponsePublisher
            .retry(0)
            .receive(on: DispatchQueue.main)
            .sink {_ in
            }
            receiveValue: {[weak self] result in
                guard let self = self else {return}
                self.uploadResulSubject.send(result)
            }
    }
}
