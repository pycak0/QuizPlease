//
//  GamePageItemBuilderProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

/// GamePage item builder protocol
protocol GamePageItemBuilderProtocol {

    /// Create GamePage items
    func makeItems() -> [GamePageItemProtocol]
}
