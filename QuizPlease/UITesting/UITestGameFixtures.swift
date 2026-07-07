//
//  UITestGameFixtures.swift
//  QuizPlease
//
//  Created by Codex on 07.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import Foundation

enum UITestGameFixtures {

    static let maxParticipantsGameId = "ui-test-game-max-participants"

    static func maxParticipantsGame() -> GameInfo {
        game(
            id: maxParticipantsGameId,
            name: "UI Test Game",
            maxParticipants: 11
        )
    }

    static func game(
        id: String,
        name: String,
        maxParticipants: Int,
        status: Int = 0
    ) -> GameInfo {
        let json = """
        {
          "id": "\(id)",
          "numberGame": "42",
          "nameGame": "\(name)",
          "blockData": "07 July",
          "time": "19:30",
          "description": "A stable game fixture for UI tests.",
          "text_block": "A stable game fixture for UI tests.",
          "price": "1000",
          "text": "per person",
          "place": "UI Test Place",
          "address": "Test Street, 1",
          "cityName": "Test City",
          "payment_icon": 0,
          "game_type": 0,
          "price_type": 0,
          "status": \(status),
          "blockOf": 100,
          "max_participants": \(maxParticipants),
          "is_show_promo_field": false
        }
        """
        guard
            let data = json.data(using: .utf8),
            let game = try? JSONDecoder().decode(GameInfo.self, from: data)
        else {
            preconditionFailure("Failed to decode UI test GameInfo fixture")
        }
        return game
    }
}

#endif
