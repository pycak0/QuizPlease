//
//  RatingTeamRankData.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 26.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

struct RatingTeamRankData: Decodable {
    let title: String
    let imagePath: String?

    enum CodingKeys: String, CodingKey {
        case title, image
        case imagePath = "image_path"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        if let path = try container.decodeIfPresent(String.self, forKey: .imagePath) {
            imagePath = path
        } else {
            imagePath = try container.decodeIfPresent(RatingTeamRankImageData.self, forKey: .image)?.path
        }
    }
}
