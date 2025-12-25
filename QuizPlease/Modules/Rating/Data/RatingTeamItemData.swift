//
//  RatingTeamItemData.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 25.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

struct RatingTeamItemData: Decodable {
    let title: String
    let points: Double
    let games: Int
    let rank: RatingTeamRankData
}
