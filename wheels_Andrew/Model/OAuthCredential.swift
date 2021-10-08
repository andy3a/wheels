//
//  OAuthCredential.swift
//  wheels_Andrew
//
//  Created by Andrew on 13.08.21.
//

import Foundation
import Alamofire

struct OAuthCredential: AuthenticationCredential, Codable {
    let authenticationToken: String
    let refreshToken: String
    let expiresAt: String
    let username: String
    var isLoggedIn: Bool = false
    let expirationDate: Date

    var requiresRefresh: Bool {
        return Date(timeIntervalSinceNow: 60 * 5) > expirationDate
    }
}

extension OAuthCredential {
    init(tokenData: LoginResponse) {
        self.authenticationToken = tokenData.authenticationToken
        self.refreshToken = tokenData.refreshToken
        self.expiresAt = tokenData.expiresAt
        self.username = tokenData.username
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.expirationDate = dateFormatter.date(from: expiresAt)!
    }
}
