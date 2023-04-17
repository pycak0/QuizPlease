//
//  GamePageSubmitButtonItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension GamePageItemKind {
    static let submit = GamePageItemKind()
}

/// GamePage submit button item
struct GamePageSubmitButtonItem {

    let getTitle: () -> String
    let tapAction: (() -> Void)?

    init(
        getTitle: @autoclosure @escaping () -> String,
        tapAction: (() -> Void)?
    ) {
        self.getTitle = getTitle
        self.tapAction = tapAction
    }
}

// MARK: - GamePageItemProtocol

extension GamePageSubmitButtonItem: GamePageItemProtocol {

    var kind: GamePageItemKind {
        .submit
    }

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageSubmitButtonCell.self
    }
}
