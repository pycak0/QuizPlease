//
//  GamePageCheckboxItem.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage checkbox item
struct GamePageCheckboxItem {

    /// item kind
    let kind: GamePageItemKind
    /// checkbox title
    let title: String
    /// selection state provider
    let getIsSelected: () -> Bool
    /// selection change handler
    let onValueChange: ((Bool) -> Void)?

    init(
        kind: GamePageItemKind,
        title: String,
        getIsSelected: @autoclosure @escaping () -> Bool,
        onValueChange: ((Bool) -> Void)?
    ) {
        self.kind = kind
        self.title = title
        self.getIsSelected = getIsSelected
        self.onValueChange = onValueChange
    }
}

// MARK: - GamePageItemProtocol

extension GamePageCheckboxItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageCheckboxCell.self
    }
}
