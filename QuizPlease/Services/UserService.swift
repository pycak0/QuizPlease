//
//  UserService.swift
//  QuizPlease
//
//  Created by Assistant on 03.01.2026.
//

import Foundation

protocol UserService {
    func getUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void)
    func loadUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void)
    func deleteAccount(completion: @escaping (Result<Void, NetworkServiceError>) -> Void)

    /// Проверяет срок действия сохранённого токена и при необходимости обновляет его.
    /// В любом случае выставляет актуальный AppSettings.userToken (или nil при ошибке/отсутствии данных).
    func updateToken(completion: (() -> Void)?)

    func logout()

    var isloggedIn: Bool { get }
}

extension UserService {

    func updateToken() {
        updateToken(completion: nil)
    }
}

final class UserServiceImpl: UserService {

    private let networkService: NetworkServiceProtocol
    private let defaults: DefaultsManager
    private let log: Logger
    private let authService: AuthService

    // MARK: - In-memory cache (5 минут)

    private let cacheQueue = DispatchQueue(label: "ru.quizplease.userService.cache", qos: .userInitiated)
    private var cachedUserInfo: UserInfo?
    private var cachedUserInfoDate: Date?
    private let userInfoCacheTTL: TimeInterval = 5 * 60

    var isloggedIn: Bool {
        authService.isLoggedIn
    }

    init(
        networkService: NetworkServiceProtocol,
        defaults: DefaultsManager,
        log: Logger,
        authService: AuthService
    ) {
        self.networkService = networkService
        self.defaults = defaults
        self.log = log
        self.authService = authService
    }

    func getUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void) {
        // Попытка вернуть валидный кэш
        if let cached = cacheQueue.sync(execute: { () -> UserInfo? in
            guard let value = cachedUserInfo, let date = cachedUserInfoDate else { return nil }
            let isValid = Date().timeIntervalSince(date) < userInfoCacheTTL
            return isValid ? value : nil
        }) {
            log.info("UserService: returning cached UserInfo")
            completion(.success(cached))
            return
        }

        // Кэш пуст/просрочен — запрос в сеть
        loadUserInfo(completion: completion)
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
                // Обновляем кэш
                self.cacheQueue.async {
                    self.cachedUserInfo = response.data
                    self.cachedUserInfoDate = Date()
                }
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
                    // Разлогин при успешном удалении аккаунта
                    self.logout()
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
        authService.updateToken(completion: completion)
    }

    func logout() {
        authService.logout()
        cacheQueue.async {
            self.cachedUserInfo = nil
            self.cachedUserInfoDate = nil
        }
    }
}
