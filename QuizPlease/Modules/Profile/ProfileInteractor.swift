//
//  ProfileInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

// MARK: - Interactor Protocol
protocol ProfileInteractorProtocol {
    /// must be weak
    var delegate: ProfileInteractorDelegate? { get set }

    func loadUserInfo()

    /// Performs only LOCAL logout from app, e.g. removing user's auth info
    func logOut()

    /// Calls backend to delete user's account. Does not clear local auth info.
    func deleteUserAccount()

    /// Returns true if onboaring was already presented
    func wasProfileOnboardingPresented() -> Bool

    /// Set that onboarding was already presented on this device
    func markOnboardingPresented()
}

// MARK: - Delegate Protocol
protocol ProfileInteractorDelegate: AnyObject {
    func didFailLoadingUserInfo(with error: NetworkServiceError)

    func didSuccessfullyLoadUserInfo(_ userInfo: UserInfo)

    func didSuccessfullyDeleteAccount()

    func didFailDeletingAccount(with error: NetworkServiceError)
}

final class ProfileInteractor: ProfileInteractorProtocol {

    private let networkService: NetworkServiceProtocol
    private let log: Logger
    private let userInfoLoader: UserInfoLoaderProtocol

    weak var delegate: ProfileInteractorDelegate?

    init(
        networkService: NetworkServiceProtocol,
        log: Logger,
        userInfoLoader: UserInfoLoaderProtocol
    ) {
        self.networkService = networkService
        self.log = log
        self.userInfoLoader = userInfoLoader
    }

    // MARK: - Load User Info
    func loadUserInfo() {
        userInfoLoader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(userInfo):
                self.delegate?.didSuccessfullyLoadUserInfo(userInfo)
            case let .failure(error):
                self.log.error("Error loading user info: \(error.localizedDescription)")
                self.delegate?.didFailLoadingUserInfo(with: error)
            }
        }
    }

    func logOut() {
        AppSettings.userToken = nil
        DefaultsManager.shared.removeAuthInfo()
    }

    func deleteUserAccount() {
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
                    self.delegate?.didSuccessfullyDeleteAccount()
                } else {
                    self.log.error("Error deleting account")
                    self.delegate?.didFailDeletingAccount(with: .serverError(1000))
                }
            case let .failure(error):
                self.log.error("Error deleting account: \(error.localizedDescription)")
                self.delegate?.didFailDeletingAccount(with: error)
            }
        }
    }

    func wasProfileOnboardingPresented() -> Bool {
        DefaultsManager.shared.wasProfileOnboardingPresented()
    }

    func markOnboardingPresented() {
        DefaultsManager.shared.setProfileOnboardingWasPresented()
    }
}

