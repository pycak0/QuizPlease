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

    func getIsUserLoggedIn() -> Bool

    func loadUserInfo()

    func loadSignedUpGames()

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

    func didSuccessfullyLoadSignedUpGames(_ games: [SignedUpGame])

    func didFailLoadingSignedUpGames(with error: NetworkServiceError)

    func didSuccessfullyDeleteAccount()

    func didFailDeletingAccount(with error: NetworkServiceError)
}

final class ProfileInteractor: ProfileInteractorProtocol {

    private let log: Logger
    private let userService: UserService

    weak var delegate: ProfileInteractorDelegate?

    init(
        userService: UserService,
        log: Logger
    ) {
        self.userService = userService
        self.log = log
    }

    func getIsUserLoggedIn() -> Bool {
        userService.isloggedIn
    }

    // MARK: - Load User Info
    func loadUserInfo() {
        userService.getUserInfo { [weak self] result in
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

    func loadSignedUpGames() {
        userService.getSignedUpGames { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(games):
                self.delegate?.didSuccessfullyLoadSignedUpGames(games)
            case let .failure(error):
                self.log.error("Error loading signed-up games: \(error.localizedDescription)")
                self.delegate?.didFailLoadingSignedUpGames(with: error)
            }
        }
    }

    func logOut() {
        userService.logout()
    }

    func deleteUserAccount() {
        userService.deleteAccount { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.delegate?.didSuccessfullyDeleteAccount()
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
