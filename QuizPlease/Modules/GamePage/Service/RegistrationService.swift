//
//  RegistrationService.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Service that manages register form
protocol RegistrationServiceProtocol: GamePageRegisterFormProvider {

    /// Loads necessary registration data about the game
    func loadData()

    /// Provides a reference to the managed register form
    func getRegisterForm() -> RegisterForm

    /// Provides a custom fields array with editable user input properties
    func getCustomFields() -> [CustomFieldModel]
}

/// Service that manages register form
final class RegistrationService {

    private let gameInfoLoader: GameInfoLoader
    private let registerForm: RegisterForm
    private var customFields: [CustomFieldModel] = []

    /// Initialize `RegistrationService`
    /// - Parameters:
    ///   - gameId: Game identifier
    ///   - gameInfoLoader: Service that loads Game info
    ///
    /// Creates a new register form
    init(gameId: Int, gameInfoLoader: GameInfoLoader) {
        self.registerForm = RegisterForm(
            cityId: AppSettings.defaultCity.id,
            gameId: gameId
        )
        self.gameInfoLoader = gameInfoLoader
    }
}

// MARK: - RegistrationServiceProtocol

extension RegistrationService: RegistrationServiceProtocol {

    func loadData() {
        gameInfoLoader.load(gameId: registerForm.gameId) { [weak self] result in
            guard let self, let gameInfo = try? result.get() else { return }
            self.customFields = gameInfo.customFields?.map { CustomFieldModel(data: $0) } ?? []
        }
    }

    func getRegisterForm() -> RegisterForm {
        registerForm
    }

    func getCustomFields() -> [CustomFieldModel] {
        customFields
    }
}
