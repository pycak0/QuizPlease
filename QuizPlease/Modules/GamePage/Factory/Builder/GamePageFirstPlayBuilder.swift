//
//  GamePageFirstPlayBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage first play checkbox item builder
final class GamePageFirstPlayBuilder {

    private let registerFormProvider: GamePageRegisterFormProvider

    init(registerFormProvider: GamePageRegisterFormProvider) {
        self.registerFormProvider = registerFormProvider
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageFirstPlayBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        let registerForm = registerFormProvider.getRegisterForm()
        return [
            GamePageCheckboxItem(
                kind: .firstPlay,
                title: "Мы играем в первый раз",
                getIsSelected: registerForm.isFirstTime,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.isFirstTime = newValue
                }
            )
        ]
    }
}
