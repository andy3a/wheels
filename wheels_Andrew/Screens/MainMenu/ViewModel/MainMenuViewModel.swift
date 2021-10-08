//
//  MainMenuViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 2.08.21.
//

import Foundation
import UIKit
import Combine

class MainMenuViewModel {

    private var getQuestionSection: AnyCancellable?
    private let reloadSubject = PassthroughSubject<Void, Never>()
    var reloadPublisher: AnyPublisher<Void, Never> {
        reloadSubject.eraseToAnyPublisher()
    }
    
    let personalButtonTitle = "Персональная тренировка"
    let personalButtonSubTitle = "Прорабатывайте проблемные вопросы"
    
    func checkIfUserLoggedIn() {
        UserManagementStorage.shared.oAuthCredentials = UserManagementStorage.shared.getOAuthCredential()
    }
}
