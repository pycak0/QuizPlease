//
//  GamePagePaymentSumItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

extension GamePageItemKind {
    static let paymentSum = GamePageItemKind()
}

/// GamePage payment sum item
struct GamePagePaymentSumItem {

    let getPaymentSum: () -> Double
    let getCurrencySymbol: () -> String
    let getPriceTextColor: () -> UIColor

    init(
        getPaymentSum: @escaping () -> Double,
        getCurrencySymbol: @escaping () -> String,
        getPriceTextColor: @escaping () -> UIColor
    ) {
        self.getPaymentSum = getPaymentSum
        self.getCurrencySymbol = getCurrencySymbol
        self.getPriceTextColor = getPriceTextColor
    }
}

// MARK: - GamePageItemProtocol

extension GamePagePaymentSumItem: GamePageItemProtocol {

    var kind: GamePageItemKind {
        .paymentSum
    }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePagePaymentSumCell.self
    }
}
