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

protocol PaymentSectionViewUpdater: AnyObject {

    /// If `items` is empty, should remove any payment count items, if any existing
    func updatePaymentCountAndSumItems(with items: [GamePageItemProtocol])
}

/// GamePage payment section output protocol
protocol GamePagePaymentSectionOutput: AnyObject {

    /// Notifies that payment type has been changed
    func didChangePaymentType()

    /// Notifies that payment count has been changed
    func didChangePaymentCount()
}

/// GamePage payment section items builder
final class GamePagePaymentSectionBuilder {

    weak var viewUpdater: PaymentSectionViewUpdater?
    weak var output: GamePagePaymentSectionOutput?

    // MARK: - Private Properties

    private let paymentInfoProvider: GamePagePaymentInfoProvider

    // MARK: - Lifecycle

    init(paymentInfoProvider: GamePagePaymentInfoProvider) {
        self.paymentInfoProvider = paymentInfoProvider
    }

    // MARK: - Private Methods

    private func makePaymentTypeItems() -> [GamePageItemProtocol] {
        let paymentTypeNames = paymentInfoProvider.getAvailablePaymentTypes().map(\.name)
        return [
            GamePageTextItem.paymentTypeHeader,
            GamePagePaymentTypeItem(
                paymentTypeNames: paymentTypeNames,
                getSelectedPaymentType: { [weak paymentInfoProvider] in
                    paymentInfoProvider?.getSelectedPaymentType().name ?? PaymentType.cash.name
                },
                onSelectionChange: { [weak self] newValue in
                    guard let self else { return }
                    if let type = PaymentType(name: newValue) {
                        self.paymentInfoProvider.setPaymentType(type)
                        self.viewUpdater?.updatePaymentCountAndSumItems(with: self.makePaymentCountAndSumItems())
                        self.output?.didChangePaymentType()
                    }
                }
            )
        ]
    }

    private func makePaymentCountItems() -> [GamePageItemProtocol] {
        guard
            paymentInfoProvider.supportsSelectPaidPeopleCount(),
            paymentInfoProvider.getSelectedPaymentType() == .online
        else {
            return []
        }
        return [
            GamePageTeamCountItem(
                kind: .paymentCount,
                title: nil,
                pickerColor: .systemBackgroundAdapted,
                backgroundColor: .systemGray5Adapted,
                getMinCount: 1,
                getMaxCount: self.paymentInfoProvider.getNumberOfPeopleInTeam(),
                getSelectedTeamCount: self.paymentInfoProvider.getSelectedNumberOfPeopleToPay(),
                changeHandler: { [weak paymentInfoProvider, weak output] newValue in
                    paymentInfoProvider?.setNumberOfPeopleToPay(newValue)
                    output?.didChangePaymentCount()
                }
            ),
            GamePageTextItem.paymenCountFooter
        ]
    }

    private func makePaymentSumItems() -> [GamePageItemProtocol] {
        guard paymentInfoProvider.getSelectedPaymentType() == .online else { return [] }
        return [
            GamePagePaymentSumItem(
                getPaymentSum: { [weak paymentInfoProvider] in
                    paymentInfoProvider?.calculatePaymentSum() ?? 0
                },
                getPriceTextColor: { [weak paymentInfoProvider] in
                    let anyDiscounts = paymentInfoProvider?.hasAnyDiscounts() ?? false
                    return anyDiscounts ? .lightGreen : .labelAdapted
                }
            )
        ]
    }

    private func makePaymentCountAndSumItems() -> [GamePageItemProtocol] {
        return makePaymentCountItems()
            + makePaymentSumItems()
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePagePaymentSectionBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return makePaymentTypeItems()
            + makePaymentCountAndSumItems()
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
            topInset: 0,
            bottomInset: 20,
            backgroundColor: .systemGray5Adapted,
            font: .gilroy(.semibold, size: 12),
            textColor: .lightGray,
            textAlignment: .center
        )
    }
}
