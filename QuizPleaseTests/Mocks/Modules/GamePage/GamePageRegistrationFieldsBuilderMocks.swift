//
//  GamePageRegistrationFieldsBuilderMocks.swift
//  QuizPleaseTests
//
//  Created by Codex on 31.03.2026.
//

@testable import QuizPlease

final class GamePageRegisterFormProviderMock: GamePageRegisterFormProvider {

    let registerForm = RegisterForm(cityId: 1, gameId: "game-id")

    func getRegisterForm() -> RegisterForm {
        registerForm
    }

    func getCustomFields() -> [CustomFieldModel] {
        []
    }
}

final class GamePageTableInfoProviderMock: GamePageTableInfoProvider {

    var tables: [GameTable] = []

    func getPriceKind() -> PriceKind {
        .table
    }

    func getAvailableTables() -> [GameTable] {
        tables
    }
}
