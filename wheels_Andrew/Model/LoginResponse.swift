//
//  LoginResponse.swift
//  wheels_Andrew
//
//  Created by Andrew on 11.08.21.
//

import Foundation

struct LoginResponse: Decodable {
    let authenticationToken: String
    let refreshToken: String
    let expiresAt: String
    let username: String
}
