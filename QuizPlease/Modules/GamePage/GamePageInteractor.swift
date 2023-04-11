//
//  GamePageInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage interactor protocol
protocol GamePageInteractorProtocol: GameStatusProvider,
                                     GamePageAnnotationProvider {

    /// Get Game full title
    func getGameTitle() -> String

    /// Path of backgorund image in the header of GamePage
    func getHeaderImagePath() -> String
}

/// GamePage interactor
final class GamePageInteractor {

    private let gameInfo: GameInfo

    /// GamePage interactor initializer
    /// - Parameter gameInfo: Game information
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
}

// MARK: - GamePageInteractorProtocol

extension GamePageInteractor: GamePageInteractorProtocol {

    func getGameTitle() -> String {
        return gameInfo.fullTitle
    }

    func getHeaderImagePath() -> String {
        return gameInfo.backgroundImagePath?.pathProof ?? ""
    }
}

// MARK: - GameStatusProvider

extension GamePageInteractor: GameStatusProvider {

    func getGameStatus() -> GameStatus {
        gameInfo.gameStatus ?? .noPlaces
    }
}

// MARK: - GamePageAnnotationProvider

extension GamePageInteractor: GamePageAnnotationProvider {

    func getAnnotation() -> String {
        gameInfo.description
    }
}
