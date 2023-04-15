//
//  GamePageSpecialConditionsBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 15.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

protocol GamePageSpecialConditionsOutput: AnyObject {

    func didChangeSpecialCondition()
    func didPressAddSpecialCondition()
}

/// GamePage special condition items builder
final class GamePageSpecialConditionsBuilder {

    weak var output: GamePageSpecialConditionsOutput?

    private let specialConditionsProvider: SpecialConditionsProvider

    init(specialConditionsProvider: SpecialConditionsProvider) {
        self.specialConditionsProvider = specialConditionsProvider
    }

    private func makeHeaderItem() -> GamePageItemProtocol {
        GamePageTextItem(
            text: "У вас есть промокод / сертификат\nКвиз, плиз! ?",
            topInset: 16,
            bottomInset: 6,
            backgroundColor: .lightGreen.withAlphaComponent(0.2),
            font: .gilroy(.semibold, size: 16),
            textColor: .labelAdapted
        )
    }

    private func makeFooterItem() -> GamePageItemProtocol {
        GamePageTextItem(
            text: "Для активации сертификатов от наших\nпартнеров свяжитесь с нами",
            topInset: 8,
            bottomInset: 16,
            backgroundColor: .lightGreen.withAlphaComponent(0.2),
            font: .gilroy(.semibold, size: 12),
            textColor: .lightGray,
            textAlignment: .center
        )
    }

    private func makeSpecialConditions() -> [GamePageItemProtocol] {
        let conditions = specialConditionsProvider.getSpecialConditions()
        var items: [GamePageItemProtocol] = conditions.enumerated().map { (index, condition) in
            GamePageFieldItem(
                title: "Введите номер сертификата/промокода",
                placeholder: "XXXXXXX",
                options: .basic,
                bottomInset: (index == conditions.count - 1) ? 8 : 0,
                valueProvider: condition.value,
                fieldColor: .systemBackgroundAdapted,
                backgroundColor: .lightGreen.withAlphaComponent(0.2),
                onValueChange: { [weak condition, weak output] newValue in
                    condition?.value = newValue
                    output?.didChangeSpecialCondition()
                }
            )
        }
        let hasAnyFilledValue = conditions.first(where: { !($0.value?.isEmpty ?? true) }) != nil
        if !conditions.isEmpty && hasAnyFilledValue {
            let addItem = GamePageAddSpecialConditionItem(tapAction: { [weak output] in
                output?.didPressAddSpecialCondition()
            })
            items.append(addItem)
        }
        return items
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageSpecialConditionsBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return [makeHeaderItem()]
        + makeSpecialConditions()
        + [makeFooterItem()]
    }
}
