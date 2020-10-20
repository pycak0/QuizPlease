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
    private var bonus_points: String?
    var games: [PassedGame]?
}

extension UserInfo {
    var pointsAmount: Int {
        Int(Double(bonus_points ?? "0") ?? 0)
    }
}