//
//  RegistrationViewModel.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import UIKit

class RegistrationViewModel {
    
    func registerUser(email: String, phone: String, name: String, password: String) {
        let registerRequest = RegisterRequest(email: email, password: password, phone: phone, username: name)
        UserManagementStorage.shared.registerUser(registerRequest: registerRequest)
    }

}
