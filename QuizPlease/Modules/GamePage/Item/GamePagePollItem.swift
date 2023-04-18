//
//  GamePagePollItem.swift
//  QuizPlease
//
//  Created by Владислав on 19.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage poll item
struct GamePagePollItem {

    let kind: GamePageItemKind
    let title: String
    let values: [String]
    let isRequired: Bool
    let getSelectedValue: () -> String?
    let onSelectionChange: ((String?) -> Void)?

    init(
        kind: GamePageItemKind,
        title: String,
        values: [String],
        isRequired: Bool,
        getSelectedValue: @escaping () -> String?,
        onSelectionChange: ((String?) -> Void)?
    ) {
        self.kind = kind
        self.title = title
        self.values = values
        self.isRequired = isRequired
        self.getSelectedValue = getSelectedValue
        self.onSelectionChange = onSelectionChange
    }
}

// MARK: - GamePageItemProtocol

extension GamePagePollItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePagePollCell.self
    }
}
