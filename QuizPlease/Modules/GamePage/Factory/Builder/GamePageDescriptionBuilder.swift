//
//  GamePageDescriptionBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage description item builder
final class GamePageDescriptionBuilder {

    private let descriptionProvider: GamePageDescriptionProvider

    /// Initialize `GamePageDescriptionBuilder`
    /// - Parameter descriptionProvider: GamePage description provider
    init(descriptionProvider: GamePageDescriptionProvider) {
        self.descriptionProvider = descriptionProvider
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageDescriptionBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        if let description = descriptionProvider.getDescription() {
            let item = GamePageDescriptionItem(description: description)
            return [item]
        }
        return []
    }
}
