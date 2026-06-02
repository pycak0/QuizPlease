//
//  UserInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class UserInfo: Decodable {

    private let bonus_points: Double?
    private let subscribe_games: [String]?

    let phone: String?
    let games: [PassedGame]?

    lazy var pointsAmount: Double = {
        bonus_points ?? 0
    }()

    lazy var subscribedGames: Set<String> = {
        subscribe_games?.reduce(into: Set<String>(), { partialResult, id in
            partialResult.insert(id)
        }) ?? Set()
    }()
}
