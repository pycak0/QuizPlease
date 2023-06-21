//
//  UserInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class UserInfo: Decodable {

    private let bonus_points: [String: Double]?
    private let subscribe_games: [String]?

    let phone: String?
    let games: [PassedGame]?

    lazy var pointsAmount: Double = {
        bonus_points?[AppSettings.defaultCity.title] ?? 0
    }()

    lazy var subscribedGames: Set<Int> = {
        subscribe_games?.reduce(into: Set<Int>(), { partialResult, id in
            if let id = Int(id) {
                partialResult.insert(id)
            }
        }) ?? Set()
    }()
}
