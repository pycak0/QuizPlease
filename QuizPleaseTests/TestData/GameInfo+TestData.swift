//
//  GameInfo+TestData.swift
//  QuizPleaseTests
//
//  Created by Владислав on 15.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease

extension GameInfo {

    static let test: GameInfo = {
        var game = GameInfo()
        game.id = 100
        return game
    }()
}
