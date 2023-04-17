//
//  GamePagePaymentSectionBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

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
}
