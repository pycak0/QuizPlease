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
    func deleteUserInfo()
}

// MARK: - Delegate Protocol
protocol ProfileInteractorDelegate: AnyObject {
    func didFailLoadingUserInfo(with error: NetworkServiceError)

    func didSuccessfullyLoadUserInfo(_ userInfo: UserInfo)
}

class ProfileInteractor: ProfileInteractorProtocol {
    weak var delegate: ProfileInteractorDelegate?

    // MARK: - Load User Info
    func loadUserInfo() {
        NetworkService.shared.getUserInfo { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.delegate?.didFailLoadingUserInfo(with: error)
            case let .success(userInfo):
                self.delegate?.didSuccessfullyLoadUserInfo(userInfo)
            }
        }
    }

    func deleteUserInfo() {
        AppSettings.userToken = nil
        DefaultsManager.shared.removeAuthInfo()
    }
}
