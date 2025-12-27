//
//  RatingTeamDataToItemMapper.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 26.12.2025.
//  Copyright © 2025 Владислав.
//  

import Foundation

/// Abstraction for mapping `RatingTeamItemData` (new rating API models) to `RatingTeamItem` (UI/domain model).
protocol RatingTeamDataToItemMapper {
    /// Maps a single data item to a UI item.
    /// - Parameters:
    ///   - data: Source model from the new rating API.
    ///   - place: Team position in the rating (not present in `data`, provided by caller).
    /// - Returns: A `RatingTeamItem` ready for UI consumption.
    func map(_ data: RatingTeamItemData, place: Int) -> RatingTeamItem

    /// Maps an array of data items to UI items.
    /// - Parameters:
    ///   - data: Source array from the new rating API.
    ///   - startingPlace: The first place to assign (e.g., `(page - 1) * pageSize + 1`).
    /// - Returns: An array of `RatingTeamItem` with places assigned incrementally.
    func map(_ data: [RatingTeamItemData], startingPlace: Int) -> [RatingTeamItem]
}

extension RatingTeamDataToItemMapper {

    /// Maps an array of data items to UI items.
    /// - Parameters:
    ///   - data: Source array from the new rating API.
    /// - Returns: An array of `RatingTeamItem` with places assigned incrementally.
    func map(_ data: [RatingTeamItemData]) -> [RatingTeamItem] {
        map(data, startingPlace: 1)
    }
}

/// Default implementation of `RatingTeamDataToItemMapper`.
struct RatingTeamDataToItemMapperImpl: RatingTeamDataToItemMapper {

    func map(_ data: RatingTeamItemData, place: Int) -> RatingTeamItem {
        RatingTeamItem(
            place: place,
            name: data.title,
            games: data.games,
            pointsTotal: data.points,
            rank: data.rank?.title,
            imagePath: data.rank?.image.path
        )
    }

    func map(_ data: [RatingTeamItemData], startingPlace: Int) -> [RatingTeamItem] {
        data.enumerated().map { index, element in
            map(element, place: startingPlace + index)
        }
    }
}
