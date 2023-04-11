//
//  GamePageRegisterButtonBuilder.swift
//  QuizPlease
//
//  Created by Владислав on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Output protocol of GamePage Register button item
protocol GamePageRegisterButtonItemOutput: AnyObject {

    /// Tells the delegate that user did press register button
    func didPressRegisterButton()
}

/// GamePage Register button item builder
final class GamePageRegisterButtonBuilder {

    weak var output: GamePageRegisterButtonItemOutput?

    private let gameStatusProvider: GameStatusProvider

    /// GamePageRegisterButtonBuilder initializer
    /// - Parameter gameStatus: Status of the game
    init(gameStatusProvider: GameStatusProvider) {
        self.gameStatusProvider = gameStatusProvider
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageRegisterButtonBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        let gameStatus = gameStatusProvider.getGameStatus()
        let item = GamePageRegisterButtonItem(
            color: gameStatus.accentColor,
            title: gameStatus.buttonTitle,
            isEnabled: gameStatus.isRegistrationAvailable,
            tapAction: { [weak self] in
                self?.output?.didPressRegisterButton()
            }
        )
        return [item]
    }
}
