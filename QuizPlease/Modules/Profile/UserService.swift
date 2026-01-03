//
//  UserService.swift
//  QuizPlease
//
//  Created by Assistant on 03.01.2026.
//

import Foundation

protocol UserServiceProtocol {
    func loadUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void)
    func deleteAccount(completion: @escaping (Result<Void, NetworkServiceError>) -> Void)
}

final class UserService: UserServiceProtocol {

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
}

