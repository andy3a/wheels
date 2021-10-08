//
//  UserManagementStorage.swift
//  wheels_Andrew
//
//  Created by Andrew_Alekseyuk on 23.08.21.
//

import Foundation
import Combine
import Alamofire
import KeychainAccess

class UserManagementStorage {
    static let shared = UserManagementStorage()
    
    private init() { }
    
    private let keychain = Keychain()
    private let credentialKey = "credential"
    var oAuthCredentials: OAuthCredential?
    var loginData: LoginResponse?
    
    private var registerUserSubscription: AnyCancellable?
    private var logOutUserSubscription: AnyCancellable?
    private var loginUserSubscription: AnyCancellable?
    
    private var failedLoginResponseSubject = PassthroughSubject<String, AFError>()
    var failedLoginResponsePublisher: AnyPublisher<String, AFError> {
        failedLoginResponseSubject.eraseToAnyPublisher()
    }
    private var successLoginResponseSubject = PassthroughSubject<String, AFError>()
    var successLoginResponsePublisher: AnyPublisher<String, AFError> {
        successLoginResponseSubject.eraseToAnyPublisher()
    }
    
    func loginUser(credentials: LoginCredentials) {
        loginUserSubscription = Networking.loginUser(credentials: credentials)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .failure(let error):
                    switch error.responseCode {
                    case 401:
                        self.failedLoginResponseSubject.send("401 - Неверный логин или пароль")
                    case 403:
                        self.failedLoginResponseSubject.send("403 - Неверный логин или пароль")
                    case 404:
                        self.failedLoginResponseSubject.send("404 - Неверный логин или пароль")
                    default:
                        self.failedLoginResponseSubject.send(error.localizedDescription)
                    }
                case .finished:
                    self.successLoginResponseSubject.send("Вы успешно залогинились")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else {return}
                var credentials = OAuthCredential(tokenData: response)
                credentials.isLoggedIn = true
                self.oAuthCredentials = credentials
                do {
                    try self.setOAuthCredential(credentials)
                } catch {
                    print("Cannot set credentials")
                }
                self.loginData = response
            }
    }
    
    func logOutUser() {
        guard oAuthCredentials != nil else {return}
        let logOutUser = LogOutRequestModel(
            refreshToken: oAuthCredentials!.authenticationToken,
            username: oAuthCredentials!.username
        )
        logOutUserSubscription = Networking.loginOutUser(logOutUser: logOutUser)
            .sink { _ in
            } receiveValue: { _ in
            }
        try? removeOAuthCredential()
    }
    
    func registerUser (registerRequest: RegisterRequest) {
        registerUserSubscription = Networking.registerUser(registerRequest: registerRequest)
            .sink { _ in
            } receiveValue: { _ in
            }
    }
    
    func oauthCredential() throws -> OAuthCredential? {
        guard let storedData = try keychain.getData(credentialKey) else {
            return nil
        }
        
        return try JSONDecoder().decode(OAuthCredential.self, from: storedData)
    }
    
    func getOAuthCredential() -> OAuthCredential? {
        guard let credential = try? keychain.getData(credentialKey) else {
            return nil
        }
        return try? JSONDecoder().decode(OAuthCredential.self, from: credential)
    }
    
    func setOAuthCredential(_ newCredential: OAuthCredential) throws {
        let data = try JSONEncoder().encode(newCredential)
        try keychain.set(data, key: credentialKey)
    }
    
    func removeOAuthCredential() throws {
        try keychain.remove(credentialKey)
        oAuthCredentials = nil
    }
}
    
