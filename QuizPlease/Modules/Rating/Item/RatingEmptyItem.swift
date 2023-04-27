//
//  RatingEmptyItem.swift
//  QuizPlease
//
//  Created by Владислав on 27.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

struct RatingEmptyItem {

    let title: String
    let imageName: String
}

// MARK: - RatingItem

extension RatingEmptyItem: RatingItem {

    func cellClass() -> RatingCell.Type {
        RatingEmptyCell.self
    }
}
