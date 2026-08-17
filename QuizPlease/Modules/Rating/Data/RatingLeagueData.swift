//
//  RatingTeamRankData.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 26.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

struct RatingLeagueResponseData: Decodable {
    let result: [RatingLeagueData]
}

struct RatingLeagueData: Decodable, Equatable {
    let id: Int
    let title: String
    let code: String
    let isCreated: Bool?
    let isLoaded: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, code
        case isCreated = "is_created"
        case isLoaded = "is_loaded"
    }
}
