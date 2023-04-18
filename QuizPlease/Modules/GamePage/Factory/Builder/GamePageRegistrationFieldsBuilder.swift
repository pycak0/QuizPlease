//
//  GamePageRegistrationFieldsBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension GamePageItemKind {

    static let teamName = GamePageItemKind()
    static let captainName = GamePageItemKind()
    static let email = GamePageItemKind()
    static let phone = GamePageItemKind()
    static let teamCount = GamePageItemKind()

    static func customField(_ id: String) -> GamePageItemKind {
        GamePageItemKind(id: "CustomField_\(id)")
    }
}

protocol GamePageRegistrationFieldsOutput: AnyObject {

    func didChangeTeamCount()
}

/// Basic register fields builder
final class GamePageRegistrationFieldsBuilder {

    weak var output: GamePageRegistrationFieldsOutput?

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

    // MARK: - Basic Fields

    private func makeBasicFields() -> [GamePageItemProtocol] {
        let registerForm = registerFormProvider.getRegisterForm()
        return [
            GamePageFieldItem(
                kind: .teamName,
                title: "Название команды *",
                placeholder: "Введите название",
                options: .team,
                valueProvider: registerForm.teamName,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.teamName = newValue
            }),
            GamePageFieldItem(
                kind: .captainName,
                title: "Имя капитана *",
                placeholder: "Введите имя",
                options: .captain,
                valueProvider: registerForm.captainName,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.captainName = newValue
            }),
            GamePageFieldItem(
                kind: .email,
                title: "E-mail *",
                placeholder: "Введите почту",
                options: .email,
                valueProvider: registerForm.email,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.email = newValue
            }),
            GamePageFieldItem(
                kind: .phone,
                title: "Телефон капитана *",
                placeholder: "",
                options: .phone,
                valueProvider: registerForm.phone,
                onValueChange: { [weak registerForm] newValue in
                    registerForm?.phone = newValue
            }),
            GamePageTeamCountItem(
                kind: .teamCount,
                title: "Количество человек в команде",
                pickerColor: .systemGray5Adapted,
                backgroundColor: .systemGray6Adapted,
                getMinCount: 2,
                getMaxCount: 9,
                getSelectedTeamCount: registerForm.count,
                changeHandler: { [weak registerForm, weak output] newValue in
                    registerForm?.count = newValue
                    output?.didChangeTeamCount()
            })
        ]
    }

    // MARK: - Custom Fields

    private func makeCustomFields() -> [GamePageItemProtocol] {
        let customFields = registerFormProvider.getCustomFields()
        return customFields.compactMap { customField in
            switch customField.data.type {
            case .text:
                return makeCustomFieldTextItem(customField)
            case .radio:
                return makeCustomFieldPollItem(customField)
            case .textarea:
                return makeCustomFieldTextareaItem(customField)
            }
        }
    }

    private func makeCustomFieldTextItem(_ customField: CustomFieldModel) -> GamePageItemProtocol {
        GamePageFieldItem(
            kind: .customField(customField.data.name),
            title: customField.data.label,
            placeholder: customField.data.placeholder,
            options: .basic,
            valueProvider: customField.inputValue
        ) { [weak customField] newValue in
            customField?.inputValue = newValue
        }
    }

    private func makeCustomFieldPollItem(_ customField: CustomFieldModel) -> GamePageItemProtocol? {
        GamePagePollItem(
            kind: .customField(customField.data.name),
            title: customField.data.label,
            values: customField.data.values,
            isRequired: customField.data.isRequired,
            getSelectedValue: {
                customField.inputValue
            },
            onSelectionChange: { [weak customField] newValue in
                customField?.inputValue = newValue
            }
        )
    }

    private func makeCustomFieldTextareaItem(_ customField: CustomFieldModel) -> GamePageItemProtocol? {
        // TODO: return item
        return nil
    }

    // MARK: - Feedback Field

    private func makeFeedbackField() -> GamePageItemProtocol {
        let registerForm = registerFormProvider.getRegisterForm()
        return GamePageFieldItem(
            kind: .customField("Feedback"),
            title: "Откуда вы узнали о нас?",
            placeholder: "Расскажите",
            options: .basic,
            bottomInset: 20,
            valueProvider: registerForm.comment,
            onValueChange: { [weak registerForm] newValue in
                registerForm?.comment = newValue
            }
        )
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageRegistrationFieldsBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return makeTitleAndSubtitle()
        + makeBasicFields()
        + makeCustomFields()
        + [makeFeedbackField()]
    }
}
