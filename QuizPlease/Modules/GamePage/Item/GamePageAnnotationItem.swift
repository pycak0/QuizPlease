//
//  GamePageAnnotationItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage annotation item
struct GamePageAnnotationItem {

    /// Annotation text
    let text: String
}

// MARK: - GamePageItemProtocol

extension GamePageAnnotationItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageAnnotationCell.self
    }
}
