//
//  GamePageInfoBuilder.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage Info item builder protocol
protocol GamePageInfoBuilderProtocol {

    /// Make Info item with given Game info
    func makeItem(game: GameInfo) -> GamePageItemProtocol
}

/// GamePage Info item builder
final class GamePageInfoBuilder {

    private let placeProvider: GamePageInfoPlaceProvider

    /// Initialize `GamePageInfoBuilder`
    /// - Parameter placeProvider: Service that provides Place annotation with coordinates for GamePage
    init(placeProvider: GamePageInfoPlaceProvider) {
        self.placeProvider = placeProvider
    }
}

// MARK: - GamePageInfoBuilderProtocol

extension GamePageInfoBuilder: GamePageInfoBuilderProtocol {

    func makeItem(game: GameInfo) -> GamePageItemProtocol {
        let infoLines = [
            // price
            GamePageInfoLineViewModel(title: game.priceDetails, subtitle: nil,
                                      iconName: "banknoteIcon"),
            // date & time
            GamePageInfoLineViewModel(title: game.blockData, subtitle: "в \(game.time)",
                                      iconName: "clockIcon"),
            // place
            GamePageInfoLineViewModel(title: game.placeInfo.title, subtitle: game.placeInfo.shortAddress,
                                      iconName: "mapPointIcon"),
            // status
            GamePageInfoLineViewModel(title: game.gameStatus?.comment, subtitle: nil,
                                      iconName: game.gameStatus?.imageName)
        ]
        return GamePageInfoItem(
            infoLines: infoLines,
            placeProvider: placeProvider
        )
    }
}
