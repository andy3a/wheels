//
//  LoginViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 10.08.21.
//

import Foundation
import UIKit
import Combine

class LoginViewModel {
    
    var subscriptions = Set<AnyCancellable>()
    var response: String?
    private var showAlertSubject = PassthroughSubject<Void, Never>()
    var showAlertPublisher: AnyPublisher<Void, Never> {
        showAlertSubject.eraseToAnyPublisher()
    }
    
    private var loggedInSubject = PassthroughSubject<Void, Never>()
    var loggedInSubjectPublisher: AnyPublisher<Void, Never> {
        loggedInSubject.eraseToAnyPublisher()
    }
    
    func loginUser(username: String, password: String) {
        let credentials = LoginCredentials(username: username, password: password)
        UserManagementStorage.shared.loginUser(credentials: credentials)
        UserManagementStorage.shared.failedLoginResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] response in
                guard let self = self else {return}
                self.response = response
                self.showAlertSubject.send()
            }
            .store(in: &subscriptions)
        
        UserManagementStorage.shared.successLoginResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] response in
                guard let self = self else {return}
                self.response = response
                self.loggedInSubject.send()
            }
            .store(in: &subscriptions)
    }
}
