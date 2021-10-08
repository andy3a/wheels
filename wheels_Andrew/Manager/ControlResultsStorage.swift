//
//  ControlResultsStorage.swift
//  wheels_Andrew
//
//  Created by Andrew_Alekseyuk on 23.08.21.
//

import Foundation
import Combine
import Alamofire

class ControlResultsStorage {
    
    static let shared = ControlResultsStorage()
    
    private init() { }
    
    private var uploadResultsSubscription: AnyCancellable?
    private var uploadResultsResponseSubject = CurrentValueSubject<String, AFError>("")
    var uploadResultsResponsePublisher: AnyPublisher<String, AFError> {
        uploadResultsResponseSubject.eraseToAnyPublisher()
    }
    
    func uploadResults(results: ControlResults) {
        if results.userAnswers.isEmpty {
            uploadResultsResponseSubject.send("Вы не ответили ни на один из вопросов")
            return
        } else {
            uploadResultsResponseSubject.send("Выгрузка результатов")
        }
        uploadResultsSubscription = Networking.uploadResults(results: results)
            .retry(0)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .failure(let error):
                    self.uploadResultsResponseSubject.send(
                        "Результаты не могут быть выгружены: \n \(error.localizedDescription)"
                    )
                case .finished:
                    self.uploadResultsResponseSubject.send("Результаты выгружены")
                }
            } receiveValue: {_ in}
    }

}
