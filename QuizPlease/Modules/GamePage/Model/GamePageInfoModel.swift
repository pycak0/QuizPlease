//
//  GamePageInfoModel.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Game basic info including price details, date & time, place info and status
struct GamePageInfoModel {

    /// Formatted price details
    let priceDetails: String
    /// Fortmatted date
    let dateFormatted: String
    /// Formatted time
    let timeFormatted: String
    /// Place title (e.g. name of the bar)
    let placeTitle: String?
    /// Place address string
    let placeAddress: String
    /// Status of the game
    let status: GameStatus

    /// Initialize with `GameInfo`
    init(game: GameInfo) {
        priceDetails = game.priceDetails
        dateFormatted = game.blockData
        timeFormatted = "в \(game.time)"
        placeTitle = game.placeInfo.title
        placeAddress = game.placeInfo.shortAddress
        status = game.gameStatus ?? .ended
    }
}
