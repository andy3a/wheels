//
//  LogOutUser.swift
//  wheels_Andrew
//
//  Created by Andrew on 11.08.21.
//

import Foundation

struct LogOutRequestModel: Encodable {
    var refreshToken: String
    var username: String
}
