//
//  RatingItem.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RatingItem: Decodable, Equatable {
    let place: Int
    let name: String
    let games: Int
    let pointsTotal: Double
    let rank: String?
    private var image: String?

    enum CodingKeys: String, CodingKey {
        case teamName, count, balls, rang, rang_image, ind
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        place = try container.decode(Int.self, forKey: .ind)
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
