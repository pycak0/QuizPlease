//
//  GamePageItemFactory.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Factory protocol for GamePage items
protocol GamePageItemFactoryProtocol {

    /// Create items for GamePage
    func makeItems() -> [GamePageItemProtocol]
}

/// Class that creates items for GamePage
final class GamePageItemFactory {

    // MARK: - Private Properties

    private let annotationBuilder: GamePageItemBuilderProtocol
    private let registerButtonBuilder: GamePageItemBuilderProtocol
    private let infoBuilder: GamePageInfoBuilderProtocol
    private let descriptionBuilder: GamePageItemBuilderProtocol

    // MARK: - Lifecycle

    init(
        annotationBuilder: GamePageItemBuilderProtocol,
        registerButtonBuilder: GamePageItemBuilderProtocol,
        infoBuilder: GamePageInfoBuilderProtocol,
        descriptionBuilder: GamePageItemBuilderProtocol
    ) {
        self.annotationBuilder = annotationBuilder
        self.registerButtonBuilder = registerButtonBuilder
        self.infoBuilder = infoBuilder
        self.descriptionBuilder = descriptionBuilder
    }

    // MARK: - Private Methods

    private func makeTitleAndSubtitle() -> [GamePageItemProtocol] {
        return [
            GamePageTextItem(
                text: "Запись на игру",
                style: .title,
                topInset: 16,
                bottomInset: 8
            ),
            GamePageTextItem(
                text: "Введите ваши данные и нажмите на кнопку «Записаться на игру»",
                style: .subtitle,
                topInset: 0,
                bottomInset: 16
            )
        ]
    }
}

// MARK: - GamePageItemFactoryProtocol

extension GamePageItemFactory: GamePageItemFactoryProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return annotationBuilder.makeItems()
        + registerButtonBuilder.makeItems()
        + [infoBuilder.makeItem()]
        + descriptionBuilder.makeItems()
        + makeTitleAndSubtitle()
    }
}
