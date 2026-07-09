//
//  RatingTeamItem.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав.
//  

import Foundation

/// A team entry in the rating list used by the UI layer.
struct RatingTeamItem: Decodable, Equatable {

    /// Team position in the rating.
    var place: Int

    /// Team display name.
    let name: String

    /// Number of games played.
    let games: Int

    /// Total points scored.
    let pointsTotal: Double

    /// Rank title (if any).
    /// Mirrors `rank.title` from the new API.
    let rank: String?

    /// Path to the rank image (if any).
    /// Mirrors `rank.image_path` from the external rating API.
    private var image: String?

    enum CodingKeys: String, CodingKey {
        case teamName, count, balls, rang, rang_image, ind
    }

    /// Decodes a team item from the legacy API payload.
    /// - Parameter decoder: Decoder containing legacy keys.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        place = try container.decode(Int.self, forKey: .ind)
        name = try container.decode(String.self, forKey: .teamName)
        games = try container.decode(Int.self, forKey: .count)
        pointsTotal = try container.decode(Double.self, forKey: .balls)
        rank = try? container.decode(String.self, forKey: .rang)
        image = try? container.decode(String.self, forKey: .rang_image)
    }

    /// Creates a team item from explicit values (preferred for the new API models).
    /// - Parameters:
    ///   - place: Team position in the rating.
    ///   - name: Team display name.
    ///   - games: Number of games played.
    ///   - pointsTotal: Total points scored.
    ///   - rank: Rank title, if available.
    ///   - imagePath: Path to the rank image, if available.
    init(
        place: Int,
        name: String,
        games: Int,
        pointsTotal: Double,
        rank: String?,
        imagePath: String?
    ) {
        self.place = place
        self.name = name
        self.games = games
        self.pointsTotal = pointsTotal
        self.rank = rank
        self.image = imagePath
    }
}

extension RatingTeamItem {
    /// Rank image path (if available).
    var imagePath: String? { image }
}

extension RatingTeamItem: RatingItem {
    func cellClass() -> RatingCell.Type {
        RatingTeamCell.self
    }
}
