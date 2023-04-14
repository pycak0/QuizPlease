//
//  GamePageInfoBuilder.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Info item output protocol
protocol GamePageInfoOutput: AnyObject {

    /// Tells the delegate that user did tap on map
    func didTapOnMap()
}

/// GamePage Info item builder
final class GamePageInfoBuilder {

    /// Info item output
    weak var output: GamePageInfoOutput?

    private let infoProvider: GamePageInfoProvider

    /// Initialize `GamePageInfoBuilder`
    /// - Parameters:
    ///   - infoProvider: GamePage game info provider
    init(infoProvider: GamePageInfoProvider) {
        self.infoProvider = infoProvider
    }
}

// MARK: - GamePageInfoBuilderProtocol

extension GamePageInfoBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
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
        let item = GamePageInfoItem(
            infoLines: infoLines,
            placeProvider: infoProvider,
            tapOnMapAction: { [weak self] in
                self?.output?.didTapOnMap()
            }
        )
        return [item]
    }
}
