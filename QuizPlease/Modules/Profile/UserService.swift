//
//  UserService.swift
//  QuizPlease
//
//  Created by Assistant on 03.01.2026.
//

import Foundation

protocol UserService {
    func loadUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void)
    func deleteAccount(completion: @escaping (Result<Void, NetworkServiceError>) -> Void)

    /// Проверяет срок действия сохранённого токена и при необходимости обновляет его.
    /// В любом случае выставляет актуальный AppSettings.userToken (или nil при ошибке/отсутствии данных).
    func updateToken(completion: (() -> Void)?)
}

extension UserService {

    func updateToken() {
        updateToken(completion: nil)
    }
}

final class UserServiceImpl: UserService {

    private let networkService: NetworkServiceProtocol
    private let log: Logger

    init(
        networkService: NetworkServiceProtocol,
        log: Logger
    ) {
        self.networkService = networkService
        self.log = log
    }

    func loadUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void) {
        let parameters: [String: String?] = [
            "city_id": "\(AppSettings.defaultCity.id)"
        ]
        networkService.get(
            ServerResponse<UserInfo>.self,
            apiPath: ApiConstants.Path.currentUser,
            parameters: parameters,
            headers: nil,
            authorizationKind: .bearer,
            networkConfiguration: .standard
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion(.success(response.data))
            case let .failure(error):
                self.log.error("Error loading user info: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func deleteAccount(completion: @escaping (Result<Void, NetworkServiceError>) -> Void) {
        networkService.afPost(
            with: [:],
            queryParameters: nil,
            and: nil,
            to: "/api/users/delete",
            responseType: ServerResponse<DeleteResponse>.self,
            authorizationKind: .bearer
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                if response.data.isSuccess {
                    completion(.success(()))
                } else {
                    self.log.error("Error deleting account")
                    completion(.failure(.serverError(1000)))
                }
            case let .failure(error):
                self.log.error("Error deleting account: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func updateToken(completion: (() -> Void)?) {
        guard let info = DefaultsManager.shared.getUserAuthInfo(),
              let expireDate = info.expireDate,
              let refreshToken = info.refreshToken
        else {
            log.error("Error updating user token: no info found")
            AppSettings.userToken = nil
            completion?()
            return
        }

        guard Date() >= expireDate else {
            AppSettings.userToken = info.accessToken
            log.info("Token is still valid. Saved User Info: \(info)")
            completion?()
            return
        }

        log.info("Token is out of date. Updating ...")
        requestTokenUpdate(refreshToken: refreshToken) { [weak self] serverResult in
            guard let self else { return }
            switch serverResult {
            case let .failure(error):
                self.log.error("Error updating user token: \(error.localizedDescription). Assigning nil to AppSettings.userToken.")
                AppSettings.userToken = nil

            case let .success(newAuthInfo):
                AppSettings.userToken = newAuthInfo.accessToken
                DefaultsManager.shared.saveAuthInfo(newAuthInfo)
                self.log.info("Updated user token. New user info: \(newAuthInfo)")
            }
            completion?()
        }
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
}
