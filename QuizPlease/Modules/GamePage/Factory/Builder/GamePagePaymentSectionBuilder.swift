//
//  GamePagePaymentSectionBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension GamePageItemKind {
    static let paymentType = GamePageItemKind()
    static let paymentCount = GamePageItemKind()
}

/// GamePage payment section items builder
final class GamePagePaymentSectionBuilder {

    // MARK: - Private Properties

    private let paymentInfoProvider: GamePagePaymentInfoProvider

    // MARK: - Lifecycle

    init(paymentInfoProvider: GamePagePaymentInfoProvider) {
        self.paymentInfoProvider = paymentInfoProvider
    }

    // MARK: - Private Methods

    private func makePaymentTypeItems() -> [GamePageItemProtocol] {
        return [
            GamePageTextItem.paymentTypeHeader,
            GamePagePaymentTypeItem(
                paymentTypeNames: paymentInfoProvider.getAvailablePaymentTypeNames(),
                getSelectedPaymentType: { [weak paymentInfoProvider] in
                    paymentInfoProvider?.getSelectedPaymentTypeName() ?? ""
                },
                onSelectionChange: { [weak paymentInfoProvider] newValue in
                    paymentInfoProvider?.setPaymentType(newValue)
                }
            )
        ]
    }

    private func makePaymentCountItems() -> [GamePageItemProtocol] {
        return [
            GamePageTeamCountItem(
                kind: .paymentCount,
                title: nil,
                getMinCount: 1,
                getMaxCount: self.paymentInfoProvider.getNumberOfPeopleInTeam(),
                getSelectedTeamCount: self.paymentInfoProvider.getSelectedNumberOfPeopleToPay(),
                changeHandler: { [weak paymentInfoProvider] newValue in
                    paymentInfoProvider?.setNumberOfPeopleToPay(newValue)
                }
            ),
            GamePageTextItem.paymenCountFooter
        ]
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePagePaymentSectionBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        makePaymentTypeItems()
    }
}

private extension GamePageTextItem {

    static var paymentTypeHeader: GamePageTextItem {
        GamePageTextItem(
            kind: .paymentType,
            text: "Способ оплаты",
            topInset: 16,
            bottomInset: 8,
            backgroundColor: .systemGray5Adapted,
            font: .gilroy(.semibold, size: 16),
            textColor: .labelAdapted
        )
    }

    static var paymenCountFooter: GamePageTextItem {
        GamePageTextItem(
            kind: .paymentCount,
            text: "* Доплатить за оставшихся участников можно " +
            "будет позже по ссылке из письма или прямо на игре.",
            topInset: 16,
            bottomInset: 16,
            backgroundColor: .systemGray5Adapted,
            font: .gilroy(.semibold, size: 12),
            textColor: .lightGray,
            textAlignment: .center
        )
    }
}
