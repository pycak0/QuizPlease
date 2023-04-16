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

//protocol GamePageSpecialConditionsBuilderProtocol: GamePageItemBuilderProtocol {
//
//    func makeSpecialConditionItem(with model: SpecialCondition) -> GamePageItemProtocol
//}

/// GamePage special condition items builder
final class GamePageSpecialConditionsBuilder {

    weak var view: SpecialConditionsView?
    weak var output: GamePageSpecialConditionsOutput?

    // MARK: - Private Properties

    private let specialConditionsProvider: SpecialConditionsProvider

    // MARK: - Lifecycle

    init(specialConditionsProvider: SpecialConditionsProvider) {
        self.specialConditionsProvider = specialConditionsProvider
    }

    // MARK: - Private Methods

    private func makeHeaderItem() -> GamePageItemProtocol {
        GamePageTextItem(
            kind: .specialConditionHeader,
            text: "У вас есть промокод / сертификат\nКвиз, плиз! ?",
            topInset: 16,
            bottomInset: 6,
            backgroundColor: .lightGreen.withAlphaComponent(0.2),
            font: .gilroy(.semibold, size: 16),
            textColor: .labelAdapted
        )
    }

    private func makeSpecialConditions() -> [GamePageItemProtocol] {
        let conditions = specialConditionsProvider.getSpecialConditions()
        var items: [GamePageItemProtocol] = conditions.map { condition in
            makeSpecialConditionItem(with: condition)
        }
        let hasFilledFirstValue = conditions.first?.value != nil
        if conditions.count > 1 || hasFilledFirstValue {
            items.append(makeAddSpecialConditionItem())
        }
        return items
    }

    private func makeAddSpecialConditionItem() -> GamePageItemProtocol {
        GamePageAddSpecialConditionItem(tapAction: { [weak self] in
            guard
                let self,
                let newCondition = self.specialConditionsProvider.addSpecialCondition()
            else {
                return
            }
            self.view?.addSpecialCondition(self.makeSpecialConditionItem(with: newCondition))
            if !self.specialConditionsProvider.canAddSpecialCondition {
                self.view?.hideAddButton()
            }
        })
    }

    private func makeFooterItem() -> GamePageItemProtocol {
        GamePageTextItem(
            kind: .specialConditionFooter,
            text: "Для активации сертификатов от наших\nпартнеров свяжитесь с нами",
            topInset: 16,
            bottomInset: 16,
            backgroundColor: .lightGreen.withAlphaComponent(0.2),
            font: .gilroy(.semibold, size: 12),
            textColor: .lightGray,
            textAlignment: .center
        )
    }

    private func makeSpecialConditionItem(with model: SpecialCondition) -> GamePageItemProtocol {
        GamePageFieldItem(
            kind: .specialCondition,
            title: "Введите номер сертификата/промокода",
            placeholder: "XXXXXXX",
            options: .basic,
            valueProvider: model.value,
            fieldColor: .systemBackgroundAdapted,
            backgroundColor: .lightGreen.withAlphaComponent(0.2),
            onValueChange: { [weak model, weak self] newValue in
                guard let self else { return }
                model?.value = newValue
                let currentConditions = self.specialConditionsProvider.getSpecialConditions()
                if currentConditions.count == 1 {
                    if newValue.isEmpty {
                        self.view?.hideAddButton()
                    } else {
                        self.view?.showAddButton(item: self.makeAddSpecialConditionItem())
                    }
                }
            },
            canBeEdited: { [weak self] in
                guard let self else { return }
                return self.specialConditionsProvider.getSpecialConditions().count > 1
            },
            swipeActions: [.delete { [weak self, weak model] in
                guard let self, let model else { return }
                let currentConditions = self.specialConditionsProvider.getSpecialConditions()
                if currentConditions.count > 1,
                   let index = currentConditions.firstIndex(where: { $0.value == nil }) {
                    self.specialConditionsProvider.removeSpecialCondition(at: index)
                    self.view?.removeSpecialCondition(at: index)
                }
            }]
        )
    }
}

// MARK: - SpecialConditionsViewOutput

extension GamePageSpecialConditionsBuilder: SpecialConditionsViewOutput {

    func didPressRemoveSpecialCondition(at index: Int) {
        specialConditionsProvider.removeSpecialCondition(at: index)
        view?.removeSpecialCondition(at: index)
        let currentConditions = specialConditionsProvider.getSpecialConditions()
        if currentConditions.count == 1 && (currentConditions.first?.value?.isEmpty ?? true) {
            view?.hideAddButton()
        }
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
