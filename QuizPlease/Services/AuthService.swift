//
//  AuthService.swift
//  QuizPlease
//
//  Created by Владислав on 03.01.2026.
//

import Foundation

protocol AuthService {
    /// Checks token expiry and refreshes if needed.
    /// Always updates the current user token (or sets to nil on error).
    func updateToken(completion: (() -> Void)?)
    /// Logs out the current user and clears relevant state.
    func logout()
    /// Returns the current access token if available.
    var userToken: String? { get }
    /// Indicates if the user is logged in.
    var isLoggedIn: Bool { get }

    // MARK: - Auth endpoints
    func register(
        _ user: UserRegisterData,
        completion: @escaping (Result<RegisterResponse, NetworkServiceError>) -> Void
    )
    func sendCode(
        to number: String,
        completion: @escaping (_ isSuccess: Bool) -> Void
    )
    func authenticate(
        phoneNumber: String,
        smsCode: String,
        firebaseId: String,
        completion: @escaping (Result<SavedAuthInfo, NetworkServiceError>) -> Void
    )
}

final class AuthServiceImpl: AuthService {

    private let networkService: NetworkServiceProtocol
    private let defaults: DefaultsManager
    private let log: Logger

    private(set) var userToken: String? {
        didSet {
            // Optionally persist, or rely on DefaultsManager for secure store.
        }
    }

    var isLoggedIn: Bool {
        userToken != nil
    }

    init(
        networkService: NetworkServiceProtocol,
        defaults: DefaultsManager,
        log: Logger
    ) {
        self.networkService = networkService
        self.defaults = defaults
        self.log = log
        self.userToken = defaults.getUserAuthInfo()?.accessToken
    }

    func updateToken(completion: (() -> Void)?) {
        guard let info = defaults.getUserAuthInfo(),
              let expireDate = info.expireDate,
              let refreshToken = info.refreshToken
        else {
            log.error("Error updating user token: no info found")
            userToken = nil
            completion?()
            return
        }

        guard Date() >= expireDate else {
            userToken = info.accessToken
            log.info("Token is still valid. Saved User Info: \(info)")
            completion?()
            return
        }

        log.info("Token is out of date. Updating ...")
        requestTokenUpdate(refreshToken: refreshToken) { [weak self] serverResult in
            guard let self else { return }
            switch serverResult {
            case let .failure(error):
                self.log.error("Error updating user token: \(error.localizedDescription). Assigning nil to userToken.")
                self.userToken = nil

            case let .success(newAuthInfo):
                self.userToken = newAuthInfo.accessToken
                self.defaults.saveAuthInfo(newAuthInfo)
                self.log.info("Updated user token. New user info: \(newAuthInfo)")
            }
            completion?()
        }
    }

    func logout() {
        defaults.removeAuthInfo()
        userToken = nil
        // Any additional logout logic can be added here if needed.
    }

    private func requestTokenUpdate(
        refreshToken: String,
        completion: @escaping (Result<SavedAuthInfo, NetworkServiceError>) -> Void
    ) {
        let params = [
            "refresh_token": refreshToken
        ]
        networkService.afPost(
            with: params,
            queryParameters: nil,
            and: nil,
            to: ApiConstants.Path.authToken,
            responseType: ServerResponse<AuthInfoResponse>.self,
            authorizationKind: .none
        ) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(response):
                let authData = response.data
                if let message = authData.message {
                    let error = NSError(domain: message, code: authData.status ?? -999, userInfo: nil)
                    completion(.failure(.other(error)))
                    return
                }
                let authInfo = SavedAuthInfo(authInfoResponse: authData)
                completion(.success(authInfo))
            }
        }
    }

    // MARK: - Auth endpoints

    func register(
        _ user: UserRegisterData,
        completion: @escaping (Result<RegisterResponse, NetworkServiceError>) -> Void
    ) {
        let parameters = [
            "phone": user.phone,
            "city_id": user.cityId
        ]
        networkService.afPost(
            with: parameters,
            queryParameters: nil,
            and: nil,
            to: ApiConstants.Path.authRegister,
            responseType: ServerResponse<RegisterResponse>.self,
            authorizationKind: .none
        ) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(serverResponse):
                completion(.success(serverResponse.data))
            }
        }
    }

    func sendCode(
        to number: String,
        completion: @escaping (_ isSuccess: Bool) -> Void
    ) {
        let parameters = [
            "phone": number
        ]
        networkService.afPost(
            with: parameters,
            queryParameters: nil,
            and: nil,
            to: ApiConstants.Path.authToken,
            responseType: [String: AnyDecodable?]?.self,
            authorizationKind: .none
        ) { result in
            let isSuccess = (try? result.get()) != nil
            completion(isSuccess)
        }
    }

    func authenticate(
        phoneNumber: String,
        smsCode: String,
        firebaseId: String,
        completion: @escaping (Result<SavedAuthInfo, NetworkServiceError>) -> Void
    ) {
        let parameters = [
            "phone": phoneNumber,
            "code": smsCode,
            "device_id": firebaseId
        ]
        networkService.afPost(
            with: parameters,
            queryParameters: nil,
            and: nil,
            to: ApiConstants.Path.authToken,
            responseType: ServerResponse<AuthInfoResponse>.self,
            authorizationKind: .none
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(serverResponse):
                let authResponse = serverResponse.data
                if let message = authResponse.message {
                    let error = NSError(domain: message, code: authResponse.status ?? -999, userInfo: nil)
                    completion(.failure(.other(error)))
                    return
                }
                let authInfo = SavedAuthInfo(authInfoResponse: authResponse)

                if let token = authInfo.accessToken {
                    self.userToken = token
                    self.defaults.saveAuthInfo(authInfo)
                }
                completion(.success(authInfo))
            }
        }
    }
}

