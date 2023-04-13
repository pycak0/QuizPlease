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
    private let infoBuilder: GamePageItemBuilderProtocol
    private let descriptionBuilder: GamePageItemBuilderProtocol
    private let basicFieldBuilder: GamePageItemBuilderProtocol

    private var info: [GamePageItemBuilderProtocol] {
        [annotationBuilder, registerButtonBuilder, infoBuilder, descriptionBuilder]
    }

    // MARK: - Lifecycle

    init(
        annotationBuilder: GamePageItemBuilderProtocol,
        registerButtonBuilder: GamePageItemBuilderProtocol,
        infoBuilder: GamePageItemBuilderProtocol,
        descriptionBuilder: GamePageItemBuilderProtocol,
        basicFieldBuilder: GamePageItemBuilderProtocol
    ) {
        self.annotationBuilder = annotationBuilder
        self.registerButtonBuilder = registerButtonBuilder
        self.infoBuilder = infoBuilder
        self.descriptionBuilder = descriptionBuilder
        self.basicFieldBuilder = basicFieldBuilder
    }

    // MARK: - Private Methods

    private func makeAllItems() -> [GamePageItemProtocol] {
        return info.makeItems()
        + makeTitleAndSubtitle()
        + basicFieldBuilder.makeItems()
    }

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
                bottomInset: 10
            )
        ]
    }
}

// MARK: - GamePageItemFactoryProtocol

extension GamePageItemFactory: GamePageItemFactoryProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        makeAllItems()
    }
}
