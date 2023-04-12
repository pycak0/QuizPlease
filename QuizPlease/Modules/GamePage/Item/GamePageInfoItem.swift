//
//  GamePageInfoItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Item with basic info of the game
struct GamePageInfoItem {

    /// Information lines
    let infoLines: [GamePageInfoLineViewModel]
    /// Place annotation provider for the map
    let placeProvider: GamePageInfoPlaceProvider
}

// MARK: - GamePageItemProtocol

extension GamePageInfoItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageInfoCell.self
    }
}
