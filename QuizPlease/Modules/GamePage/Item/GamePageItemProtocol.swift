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

    func cellClass(with context: GamePageViewContext) -> AnyClass

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

struct GamePageItemKind: Hashable {
    let id: String

    /// Create a new item kind
    /// - Parameter id: Use a randomly generated id or provide your own one
    init(id: String = UUID().uuidString) {
        self.id = id
    }
}

// MARK: - Known item kinds

extension GamePageItemKind {

    static let annotation = GamePageItemKind()
    static let info = GamePageItemKind()
    static let registrationHeader = GamePageItemKind()
    static let basicField = GamePageItemKind()
    static let customField = GamePageItemKind()
    static let specialConditionHeader = GamePageItemKind()
    static let specialCondition = GamePageItemKind()
    static let addSpecialCondition = GamePageItemKind()
    static let specialConditionFooter = GamePageItemKind()
}
