//
//  RatingItem.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RatingItem: Decodable, Equatable {
    var name: String
    var games: Int
    var pointsTotal: Double
    var rank: String?
    private var image: String?
    
    enum CodingKeys: String, CodingKey {
        case teamName, count, balls, rang, rang_image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .teamName)
        games = try container.decode(Int.self, forKey: .count)
        pointsTotal = try container.decode(Double.self, forKey: .balls)
        rank = try? container.decode(String.self, forKey: .rang)
        image = try? container.decode(String.self, forKey: .rang_image)
    }
}

extension RatingItem {
    var imagePath: String? {
        return image?.pathProof
    }
}
