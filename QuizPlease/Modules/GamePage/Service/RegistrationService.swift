//
//  RegistrationService.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Service that manages register form
protocol RegistrationServiceProtocol {

    /// Provides a reference to the managed register form
    func getRegisterForm() -> RegisterForm
}

/// Service that manages register form
final class RegistrationService {

    private let registerForm: RegisterForm

    /// Initialize `RegistrationService`
    /// - Parameter gameId: Game identifier
    ///
    /// Creates a new register form
    init(gameId: Int) {
        self.registerForm = RegisterForm(
            cityId: AppSettings.defaultCity.id,
            gameId: gameId
        )
    }
}

// MARK: - RegistrationServiceProtocol

extension RegistrationService: RegistrationServiceProtocol {

    func getRegisterForm() -> RegisterForm {
        registerForm
    }
}
