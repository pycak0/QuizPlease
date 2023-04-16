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

    private let gameStatusProvider: GameStatusProvider
    private let annotationBuilder: GamePageItemBuilderProtocol
    private let registerButtonBuilder: GamePageItemBuilderProtocol
    private let infoBuilder: GamePageItemBuilderProtocol
    private let descriptionBuilder: GamePageItemBuilderProtocol
    private let registrationFieldsBuilder: GamePageItemBuilderProtocol
    private let specialConditionsBuilder: GamePageItemBuilderProtocol
    private let firstPlayBuilder: GamePageItemBuilderProtocol

    private var info: [GamePageItemBuilderProtocol] {
        [annotationBuilder, registerButtonBuilder, infoBuilder, descriptionBuilder]
    }

    private var registration: [GamePageItemBuilderProtocol] {
        [registrationFieldsBuilder, specialConditionsBuilder]
    }

    private var all: [GamePageItemBuilderProtocol] {
        info + registration + [firstPlayBuilder]
    }

    // MARK: - Lifecycle

    init(
        gameStatusProvider: GameStatusProvider,
        annotationBuilder: GamePageItemBuilderProtocol,
        registerButtonBuilder: GamePageItemBuilderProtocol,
        infoBuilder: GamePageItemBuilderProtocol,
        descriptionBuilder: GamePageItemBuilderProtocol,
        registrationFieldsBuilder: GamePageItemBuilderProtocol,
        specialConditionsBuilder: GamePageItemBuilderProtocol,
        firstPlayBuilder: GamePageItemBuilderProtocol
    ) {
        self.gameStatusProvider = gameStatusProvider
        self.annotationBuilder = annotationBuilder
        self.registerButtonBuilder = registerButtonBuilder
        self.infoBuilder = infoBuilder
        self.descriptionBuilder = descriptionBuilder
        self.registrationFieldsBuilder = registrationFieldsBuilder
        self.specialConditionsBuilder = specialConditionsBuilder
        self.firstPlayBuilder = firstPlayBuilder
    }
}

// MARK: - GamePageItemFactoryProtocol

extension GamePageItemFactory: GamePageItemFactoryProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        if !gameStatusProvider.getGameStatus().isRegistrationAvailable {
            return info.makeItems()
        }
        return all.makeItems()
    }
//
//    func makeSpecialConditionItem(with model: SpecialCondition) -> GamePageItemProtocol {
//        specialConditionsBuilder.makeSpecialConditionItem(with: model)
//    }
}
