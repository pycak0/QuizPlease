//
//  RatingFilter.swift
//  QuizPlease
//
//  Created by Владислав on 31.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RatingFilter {
    enum RatingScope: Int, Codable {
        case season, allTime
    }
    
    enum RatingLeague: Int, Codable, CaseIterable {
        case classic = 1, movieAndMusic, teens, englishPlease, streams
        
        var name: String {
            switch self {
            case .classic:
                return "Классические игры"
            case .movieAndMusic:
                return "Кино и музыка"
            case .teens:
                return "Teens"
            case .englishPlease:
                return "English, please!"
            case .streams:
                return "Стримы"
            }
        }
    }
    
    var city: City = Globals.defaultCity
    var teamName: String = ""
    var league: RatingLeague = .classic
    var scope: RatingScope = .allTime
}
