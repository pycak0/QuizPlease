//
//  GameStatusProvider.swift
//  QuizPlease
//
//  Created by Владислав on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

/// GameStatus provider protocol
protocol GameStatusProvider {

    /// Get the status of the game
    func getGameStatus() -> GameStatus
}
