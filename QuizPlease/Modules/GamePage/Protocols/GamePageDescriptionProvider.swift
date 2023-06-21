//
//  GamePageDescriptionProvider.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage description provider
protocol GamePageDescriptionProvider {

    /// Get game description text
    func getDescription() -> NSAttributedString?
}
