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
            GamePageTextItem.title("Запись на игру"),
            GamePageTextItem.subtitle("Введите ваши данные и нажмите на кнопку «Записаться на игру»")
        ]
    }

    private func makeBasicFields() -> [GamePageItemProtocol] {
        let registerForm = registerFormProvider.getRegisterForm()
        return [
            GamePageFieldItem(
                title: "Название команды *",
                placeholder: "Введите название",
                options: .team,
                valueProvider: registerForm.teamName,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.teamName = newValue
            }),
            GamePageFieldItem(
                title: "Имя капитана *",
                placeholder: "Введите имя",
                options: .captain,
                valueProvider: registerForm.captainName,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.captainName = newValue
            }),
            GamePageFieldItem(
                title: "E-mail *",
                placeholder: "Введите почту",
                options: .email,
                valueProvider: registerForm.email,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.email = newValue
            }),
            GamePageFieldItem(
                title: "Телефон капитана *",
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
        var items = customFields.filter({ $0.data.type == .text })
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
        if !items.isEmpty {
            items[items.count - 1].bottomInset = 20
        }
        return items
    }

    private func makeSpecialConditions() -> [GamePageItemProtocol] {
        return [
            GamePageTextItem(
                text: "У вас есть промокод / сертификат\nКвиз, плиз! ?",
                topInset: 16,
                bottomInset: 6,
                backgroundColor: .lightGreen.withAlphaComponent(0.2),
                font: .gilroy(.semibold, size: 16),
                textColor: .labelAdapted
            ),
            GamePageFieldItem(
                title: "Введите номер сертификата/промокода",
                placeholder: "XXXXXXX",
                options: .basic,
                valueProvider: nil,
                fieldColor: .systemBackgroundAdapted,
                backgroundColor: .lightGreen.withAlphaComponent(0.2)
            ),
            GamePageTextItem(
                text: "Для активации сертификатов от наших\nпартнеров свяжитесь с нами",
                topInset: 16,
                bottomInset: 16,
                backgroundColor: .lightGreen.withAlphaComponent(0.2),
                font: .gilroy(.semibold, size: 12),
                textColor: .lightGray,
                textAlignment: .center
            )
        ]
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageRegistrationFieldsBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return makeTitleAndSubtitle()
        + makeBasicFields()
        + makeCustomFields()
        + makeSpecialConditions()
    }
}
