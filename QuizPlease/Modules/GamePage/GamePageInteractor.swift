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

    /// Get Place information
    func getPlaceInfo() -> Place
}

/// GamePage interactor
final class GamePageInteractor: GamePageInteractorProtocol {

    private let gameInfo: GameInfo
    private let placeGeocoder: PlaceGeocoderProtocol

    /// GamePage interactor initializer
    /// - Parameters:
    ///   - gameInfo: Game information
    ///   - placeGeocoder: Service that provides `Place` coordinates
    init(
        gameInfo: GameInfo,
        placeGeocoder: PlaceGeocoderProtocol
    ) {
        self.gameInfo = gameInfo
        self.placeGeocoder = placeGeocoder
    }

    // MARK: - GamePageInteractorProtocol

    func getGameTitle() -> String {
        return gameInfo.fullTitle
    }

    func getHeaderImagePath() -> String {
        return gameInfo.backgroundImagePath?.pathProof ?? ""
    }

    func getPlaceInfo() -> Place {
        return gameInfo.placeInfo
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

    func getPlaceAnnotation(completion: @escaping (Place) -> Void) {
        let place = gameInfo.placeInfo
        placeGeocoder.getCoordinate(place) { [weak place] coordinate in
            guard let place else { return }
            place.coordinate = coordinate
            completion(place)
        }
    }
}
