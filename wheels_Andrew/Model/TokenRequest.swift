//
//  TokenRequest.swift
//  wheels_Andrew
//
//  Created by Andrew on 13.08.21.
//

import Foundation

struct TokenRequest: Encodable {
    var refreshToken: String
    var username: String
}
