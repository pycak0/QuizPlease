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
                                     GamePageAnnotationProvider,
                                     GamePageInfoProvider {

    /// Get Game full title
    func getGameTitle() -> String

    /// Path of backgorund image in the header of GamePage
    func getHeaderImagePath() -> String
}

/// GamePage interactor
final class GamePageInteractor: GamePageInteractorProtocol {

    private let gameInfo: GameInfo
    private let placeAnnotationProvider: PlaceAnnotationProviderProtocol

    /// GamePage interactor initializer
    /// - Parameters:
    ///   - gameInfo: Game information
    ///   - placeAnnotationProvider: Service that provides Place annotation with coordinates
    init(
        gameInfo: GameInfo,
        placeAnnotationProvider: PlaceAnnotationProviderProtocol
    ) {
        self.gameInfo = gameInfo
        self.placeAnnotationProvider = placeAnnotationProvider
    }

    // MARK: - GamePageInteractorProtocol

    func getGameTitle() -> String {
        return gameInfo.fullTitle
    }

    func getHeaderImagePath() -> String {
        return gameInfo.backgroundImagePath?.pathProof ?? ""
    }

    // MARK: - GameStatusProvider

    func getGameStatus() -> GameStatus {
        gameInfo.gameStatus ?? .noPlaces
    }

    // MARK: - GamePageAnnotationProvider

    func getAnnotation() -> String {
        gameInfo.description
    }

    // MARK: - GamePageInfoProvider

    func getInfo() -> GamePageInfoModel {
        GamePageInfoModel(game: gameInfo)
    }

    func getPlace(completion: @escaping (Place) -> Void) {
        placeAnnotationProvider.getPlace(initialPlace: gameInfo.placeInfo, completion: completion)
    }
}
