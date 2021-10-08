//
//  RegisterRequest.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation

struct RegisterRequest: Encodable {
    var email: String
    var password: String
    var phone: String
    var username: String
}
