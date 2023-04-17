//
//  GamePageAgreementItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension GamePageItemKind {
    static let agreement = GamePageItemKind()
}

/// GamePage agreement item
struct GamePageAgreementItem {

    let tapAction: (() -> Void)?

    init(tapAction: (() -> Void)?) {
        self.tapAction = tapAction
    }
}

// MARK: - GamePageItemProtocol

extension GamePageAgreementItem: GamePageItemProtocol {

    var kind: GamePageItemKind {
        .agreement
    }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageAgreementCell.self
    }
}
