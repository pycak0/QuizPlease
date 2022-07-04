//
//  TeamInfo.swift
//  QuizPlease
//
//  Created by Владислав on 03.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct TeamInfo: Decodable {
    var id: Int
    var game_id: Int
    var teamName: String

    var captainName: String?
    var email: String?
    var phone: String?
    var count: Int?
    var comment: String? = ""

    private var created_at: Double?
}

extension TeamInfo {
    var createdAt: Date? {
        guard let seconds = created_at else { return nil }
        return Date(timeIntervalSince1970: seconds)
    }
}
