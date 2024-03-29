//
//  GamePageAddSpecialConditionItem.swift
//  QuizPlease
//
//  Created by Владислав on 15.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage add button item for special conditions
struct GamePageAddSpecialConditionItem {

    /// Add button pressed
    let tapAction: (() -> Void)?
}

// MARK: - GamePageItemProtocol

extension GamePageAddSpecialConditionItem: GamePageItemProtocol {

    var kind: GamePageItemKind { .addSpecialCondition }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageAddSpecialConditionCell.self
    }
}
