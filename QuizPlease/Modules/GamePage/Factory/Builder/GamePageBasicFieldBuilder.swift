//
//  GamePageBasicFieldBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Basic register fields builder
final class GamePageBasicFieldBuilder {

    private let registerFormProvider: GamePageRegisterFormProvider

    /// Initialize `GamePageBasicFieldBuilder`
    /// - Parameter registerFormProvider: RegisterForm provider
    init(registerFormProvider: GamePageRegisterFormProvider) {
        self.registerFormProvider = registerFormProvider
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageBasicFieldBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        let registerForm = registerFormProvider.getRegisterForm()
        return [
            GamePageFieldItem(
                title: "Название команды",
                placeholder: "Введите название",
                options: .team,
                valueProvider: registerForm.teamName,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.teamName = newValue
            }),
            GamePageFieldItem(
                title: "Имя капитана",
                placeholder: "Введите имя",
                options: .captain,
                valueProvider: registerForm.captainName,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.captainName = newValue
            }),
            GamePageFieldItem(
                title: "E-mail",
                placeholder: "Введите почту",
                options: .email,
                valueProvider: registerForm.email,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.email = newValue
            }),
            GamePageFieldItem(
                title: "Телефон капитана",
                placeholder: "",
                options: .phone,
                valueProvider: registerForm.phone,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.phone = newValue
            }),
            GamePageTeamCountItem(
                getSelectedTeamCount: registerForm.count,
                changeHandler: { [weak registerForm] newValue in
                    registerForm?.count = newValue
            })
        ]
    }
}
