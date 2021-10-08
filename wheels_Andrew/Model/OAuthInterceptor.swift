//
//  OAuthInterceptor.swift
//  wheels_Andrew
//
//  Created by Andrew on 13.08.21.
//

import Foundation
import Alamofire

typealias OAuthInterceptor = AuthenticationInterceptor<OAuthAuthenticator>

extension OAuthInterceptor {
    static let shared = OAuthInterceptor()
    
    private convenience init() {
        let authenticator = OAuthAuthenticator()
        let credential: OAuthCredential?
        credential = UserManagementStorage.shared.getOAuthCredential()
        self.init(authenticator: authenticator, credential: credential)
    }
    
    convenience init(credential: OAuthCredential) {
        let authenticator = OAuthAuthenticator()
        self.init(authenticator: authenticator, credential: credential)
    }
}
