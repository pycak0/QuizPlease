//
//  GamePageItemFactory.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Factory protocol for GamePage items
protocol GamePageItemFactoryProtocol {

    /// Create items for GamePage
    func makeItems() -> [GamePageItemProtocol]
}

/// Class that creates items for GamePage
final class GamePageItemFactory {

    private let registerButtonBuilder: GamePageItemBuilderProtocol

    init(registerButtonBuilder: GamePageItemBuilderProtocol) {
        self.registerButtonBuilder = registerButtonBuilder
    }
}

// MARK: - GamePageItemFactoryProtocol

extension GamePageItemFactory: GamePageItemFactoryProtocol {

    // MARK: - GamePageItemFactoryProtocol

    func makeItems() -> [GamePageItemProtocol] {
        return [
            GamePageAnnotationItem(text: """
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст
            """)
        ]
        + registerButtonBuilder.makeItems()
    }
}
