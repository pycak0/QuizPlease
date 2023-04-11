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

    private let annotationBuilder: GamePageItemBuilderProtocol
    private let registerButtonBuilder: GamePageItemBuilderProtocol

    init(
        annotationBuilder: GamePageItemBuilderProtocol,
        registerButtonBuilder: GamePageItemBuilderProtocol
    ) {
        self.annotationBuilder = annotationBuilder
        self.registerButtonBuilder = registerButtonBuilder
    }
}

// MARK: - GamePageItemFactoryProtocol

extension GamePageItemFactory: GamePageItemFactoryProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return annotationBuilder.makeItems()
        + registerButtonBuilder.makeItems()
    }
}
