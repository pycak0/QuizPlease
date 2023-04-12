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
    func makeItem() -> GamePageItemProtocol
}

/// GamePage Info item builder
final class GamePageInfoBuilder {

    private let infoProvider: GamePageInfoProvider

    /// Initialize `GamePageInfoBuilder`
    /// - Parameters:
    ///   - infoProvider: GamePage game info provider
    init(infoProvider: GamePageInfoProvider) {
        self.infoProvider = infoProvider
    }
}

// MARK: - GamePageInfoBuilderProtocol

extension GamePageInfoBuilder: GamePageInfoBuilderProtocol {

    func makeItem() -> GamePageItemProtocol {
        let gameInfo = infoProvider.getInfo()
        let infoLines = [
            // price
            GamePageInfoLineViewModel(title: gameInfo.priceDetails, subtitle: nil,
                                      iconName: "banknoteIcon"),
            // date & time
            GamePageInfoLineViewModel(title: gameInfo.dateFormatted, subtitle: gameInfo.timeFormatted,
                                      iconName: "clockIcon"),
            // place
            GamePageInfoLineViewModel(title: gameInfo.placeTitle, subtitle: gameInfo.placeAddress,
                                      iconName: "mapPointIcon"),
            // status
            GamePageInfoLineViewModel(title: gameInfo.status.comment, subtitle: nil,
                                      iconName: gameInfo.status.imageName)
        ]
        return GamePageInfoItem(
            infoLines: infoLines,
            placeProvider: infoProvider
        )
    }
}
