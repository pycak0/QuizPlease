//
//  GamePageItemProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Item protocol for game page view
protocol GamePageItemProtocol {

    var kind: GamePageItemKind { get }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type

    func isEditable() -> Bool

    func trailingSwipeActions() -> [UIContextualAction]
}

extension GamePageItemProtocol {

    func isEditable() -> Bool {
        false
    }

    func trailingSwipeActions() -> [UIContextualAction] {
        []
    }
}
