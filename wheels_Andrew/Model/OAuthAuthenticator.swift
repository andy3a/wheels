//
//  OAuthAuthenticator.swift
//  wheels_Andrew
//
//  Created by Andrew on 13.08.21.
//

import Foundation
import Alamofire

import UIKit

class OAuthAuthenticator: Authenticator {
    
    private static let refreshURL = URL(string: "https://kolesa-app.herokuapp.com/auth/refresh/token")!
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.authenticationToken))
    }
    
    func refresh(
        _ credential: OAuthCredential,
        for session: Session,
        completion: @escaping (Result<OAuthCredential, Error>) -> Void
    ) {
        let tokenRequestParameters = TokenRequest(
            refreshToken: credential.refreshToken,
            username: credential.username
        )
        session.request(
            OAuthAuthenticator.refreshURL,
            method: .post,
            parameters: tokenRequestParameters,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseDecodable(of: LoginResponse.self) { response in
            
            switch response.result {
            case .success(let tokenData):
                let credential = OAuthCredential(tokenData: tokenData)
                do {
                    try UserManagementStorage.shared.setOAuthCredential(credential)
                    completion(.success(credential))
                    
                } catch {
                    completion(.failure(error))
                    return
                }
            case .failure(let error):
                let excessiveRefresh = (error.underlyingError as? AuthenticationError) == .excessiveRefresh
                if excessiveRefresh {
                    UserManagementStorage.shared.logOutUser()
                }
                completion(.failure(error))
            }
        }
    }
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: Error
    ) -> Bool {
        return false
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        return true
    }
}
