//
//  GamePageDescriptionItem.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage description item
struct GamePageDescriptionItem {

    /// Game description
    let description: NSAttributedString
}

// MARK: - GamePageItemProtocol

extension GamePageDescriptionItem: GamePageItemProtocol {

    var kind: GamePageItemKind { .info }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageDescriptionCell.self
    }
}
