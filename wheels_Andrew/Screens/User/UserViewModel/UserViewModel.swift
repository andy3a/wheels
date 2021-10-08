//
//  UserViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import Combine

class UserViewModel {
    var username: String
    let personalButtonTitle = "Персональная тренировка"
    let personalButtonSubTitle = "Прорабатывайте проблемные вопросы"
    let controlHistoryTitle = "История контролей"
    let controlHistorySubTitle = "Учитесь на своих ошибках"
    var persentage: Double?
    var subscription: AnyCancellable?
    
    private var dataRecieverTriggerSubject = PassthroughSubject<Void, Never>()
    var dataRecieverTriggerPublisher: AnyPublisher<Void, Never> {
        dataRecieverTriggerSubject.eraseToAnyPublisher()
    }
    init (username: String) {
        self.username = username
    }
    
    func fetchPersentage() {
        PersonalPersentageStorage.shared.fetchPersentage()
        subscription = PersonalPersentageStorage.shared.personalPersentagePublisher
            .sink { _ in
            } receiveValue: { persentage in
                self.persentage = persentage
                self.dataRecieverTriggerSubject.send()
            }
    }
    
    func logOutUser() {
        UserManagementStorage.shared.logOutUser()
    }
}
