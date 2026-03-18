//
//  GamePageTableInfoProvider.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.03.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

import Foundation

/// Provides table-related info for games with «оплата со стола» pricing
protocol GamePageTableInfoProvider: AnyObject {

    /// Get the price kind for the current game
    func getPriceKind() -> PriceKind

    /// Get available tables for the current game
    func getAvailableTables() -> [GameTable]
}
