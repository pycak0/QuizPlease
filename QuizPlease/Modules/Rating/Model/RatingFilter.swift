//
//  RatingFilter.swift
//  QuizPlease
//
//  Created by Владислав on 31.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RatingFilter {
    enum RatingScope: Int, Codable, CaseIterable {
        case season, allTime

        var title: String {
            switch self {
            case .allTime:
                return "За все время"
            case .season:
                return "За сезон"
            }
        }

        var comment: String {
            switch self {
            case .allTime:
                return "за все время"
            case .season:
                return "этого сезона"
            }
        }
    }

    var city: City = AppSettings.defaultCity
    var teamName: String = ""
    var league: RatingLeagueData?
    var scope: RatingScope = .allTime
}
