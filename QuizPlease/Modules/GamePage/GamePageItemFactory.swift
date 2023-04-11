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

/// Class that creates itms for GamePage
final class GamePageItemFactory: GamePageItemFactoryProtocol {

    // MARK: - GamePageItemFactoryProtocol

    func makeItems() -> [GamePageItemProtocol] {
        return [
            GamePageAnnotationItem(text: """
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст текст текст текст текст текст
            текст текст текст текст текст
            """),
            GamePageRegisterButtonItem(
                color: <#T##UIColor#>,
                title: <#T##String#>,
                isEnabled: <#T##Bool#>,
                tapAction: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>
            )
        ]
    }
}
