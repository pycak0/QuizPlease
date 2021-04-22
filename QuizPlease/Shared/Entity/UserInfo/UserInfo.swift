//
//  UserInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class UserInfo: Decodable {
    var phone: String?
    private var bonus_points: [String: String]?
    var games: [PassedGame]?
    private var subscribe_games: [String]?
}

extension UserInfo {
    var pointsAmount: Int {
        guard let dict = bonus_points else { return 0 }
        if let points = dict[AppSettings.defaultCity.title] {
            return Int(Double(points) ?? 0)
        }
        return 0
    }
    
    var subscribedGames: [Int] {
        subscribe_games?.compactMap { Int($0) } ?? []
    }
}
