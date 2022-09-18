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

    private let networkService: NetworkService

    weak var delegate: ProfileInteractorDelegate?

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Load User Info
    func loadUserInfo() {
        networkService.getUserInfo { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.delegate?.didFailLoadingUserInfo(with: error)
            case let .success(userInfo):
                self.delegate?.didSuccessfullyLoadUserInfo(userInfo)
            }
        }
    }

    func logOut() {
        AppSettings.userToken = nil
        DefaultsManager.shared.removeAuthInfo()
    }

    func deleteUserAccount() {
        networkService.afPostStandard(
            bodyParameters: [:],
            to: "/api/users/delete",
            responseType: DeleteResponse.self,
            authorizationKind: .bearer
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(response):
                if response.isSuccess {
                    self.delegate?.didSuccessfullyDeleteAccount()
                } else {
                    self.delegate?.didFailDeletingAccount(with: .serverError(1000))
                }
            case let .failure(error):
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
