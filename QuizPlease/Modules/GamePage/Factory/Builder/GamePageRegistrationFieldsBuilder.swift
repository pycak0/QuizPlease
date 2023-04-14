//
//  GamePageRegistrationFieldsBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Basic register fields builder
final class GamePageRegistrationFieldsBuilder {

    // MARK: - Private Properties

    private let registerFormProvider: GamePageRegisterFormProvider

    // MARK: - Lifecycle

    /// Initialize `GamePageRegistrationFieldsBuilder`
    /// - Parameter registerFormProvider: RegisterForm provider
    init(registerFormProvider: GamePageRegisterFormProvider) {
        self.registerFormProvider = registerFormProvider
    }

    // MARK: - Private Methods

    private func makeTitleAndSubtitle() -> [GamePageItemProtocol] {
        return [
            GamePageTextItem(
                text: "Запись на игру",
                style: .title,
                topInset: 16,
                bottomInset: 8
            ),
            GamePageTextItem(
                text: "Введите ваши данные и нажмите на кнопку «Записаться на игру»",
                style: .subtitle,
                topInset: 0,
                bottomInset: 10
            )
        ]
    }

    private func makeBasicFields() -> [GamePageItemProtocol] {
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

    private func makeCustomFields() -> [GamePageItemProtocol] {
        let customFields = registerFormProvider.getCustomFields()
        return customFields.filter({ $0.data.type == .text })
            .map { customField in
                GamePageFieldItem(
                    title: customField.data.label,
                    placeholder: customField.data.placeholder,
                    options: .basic,
                    valueProvider: customField.inputValue
                ) { [weak customField] newValue in
                    customField?.inputValue = newValue
                }
            }
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageRegistrationFieldsBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return makeTitleAndSubtitle()
        + makeBasicFields()
        + makeCustomFields()
    }
}
