//
//  GamePagePaymentTypeItem.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension GamePageItemKind {
    static let paymentType = GamePageItemKind()
}

/// GamePage payment type selection
struct GamePagePaymentTypeItem {

    let paymentTypeNames: [String]
    let getSelectedPaymentType: () -> String
    let onSelectionChange: ((String) -> Void)?

    init(
        paymentTypeNames: [String],
        getSelectedPaymentType: @escaping () -> String,
        onSelectionChange: ((String) -> Void)?
    ) {
        self.paymentTypeNames = paymentTypeNames
        self.getSelectedPaymentType = getSelectedPaymentType
        self.onSelectionChange = onSelectionChange
    }
}

// MARK: - GamePageItemProtocol

extension GamePagePaymentTypeItem: GamePageItemProtocol {

    var kind: GamePageItemKind {
        .paymentType
    }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePagePaymentTypeCell.self
    }
}
