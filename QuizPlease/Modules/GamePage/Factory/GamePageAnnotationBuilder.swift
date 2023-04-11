//
//  GamePageAnnotationBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage annotation item builder
final class GamePageAnnotationBuilder {

    private let annotationProvider: GamePageAnnotationProvider

    /// Initialize annotation builder
    /// - Parameter annotationProvider: Annotation text provider
    init(annotationProvider: GamePageAnnotationProvider) {
        self.annotationProvider = annotationProvider
    }
}

extension GamePageAnnotationBuilder: GamePageItemBuilderProtocol {
    func makeItems() -> [GamePageItemProtocol] {
        let item = GamePageAnnotationItem(text: annotationProvider.getAnnotation())
        return [item]
    }
}

/// GamePage Annotation text provider
protocol GamePageAnnotationProvider {

    /// Get annotation text for the game
    func getAnnotation() -> String
}
