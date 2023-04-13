//
//  GamePageInfoItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Item with basic info of the game
final class GamePageInfoItem {

    /// Information lines
    let infoLines: [GamePageInfoLineViewModel]
    /// Place annotation provider for the map
    let placeProvider: GamePageInfoPlaceProvider
    /// Block that is executed when map was tapped
    let tapOnMapAction: (() -> Void)?

    init(
        infoLines: [GamePageInfoLineViewModel],
        placeProvider: GamePageInfoPlaceProvider,
        tapOnMapAction: (() -> Void)?
    ) {
        self.infoLines = infoLines
        self.placeProvider = placeProvider
        self.tapOnMapAction = tapOnMapAction
    }
}

// MARK: - GamePageItemProtocol

extension GamePageInfoItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageInfoCell.self
    }
}
