//
//  RatingItem.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RatingItem: Decodable {
    var name: String
    var games: Int
    var pointsTotal: Int
    var rank: String
    private var imageUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case teamName, count, balls, rang, rang_image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .teamName)
        games = try container.decode(Int.self, forKey: .count)
        pointsTotal = try container.decode(Int.self, forKey: .balls)
        rank = try container.decode(String.self, forKey: .rang)
        imageUrlString = try container.decode(String.self, forKey: .rang_image)
    }
}