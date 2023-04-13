//
//  GamePageAnnotationProvider.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage Annotation text provider
protocol GamePageAnnotationProvider {

    /// Get annotation text for the game
    func getAnnotation() -> String
}
