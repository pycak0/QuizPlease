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
                                     GamePageInfoProvider,
                                     GamePageDescriptionProvider {

    func loadGame(complpetion: @escaping (Error?) -> Void)

    /// Get Game full title
    func getGameTitle() -> String

    /// Path of backgorund image in the header of GamePage
    func getHeaderImagePath() -> String

    /// Get Place information
    func getPlaceInfo() -> Place
}

/// GamePage interactor
final class GamePageInteractor: GamePageInteractorProtocol {

    private var gameInfo: GameInfo
    private let gameInfoLoader: GameInfoLoader
    private let placeGeocoder: PlaceGeocoderProtocol
    private let registrationService: RegistrationServiceProtocol

    /// GamePage interactor initializer
    /// - Parameters:
    ///   - gameId: Game identifier
    ///   - gameInfoLoader: Service that loads Game info
    ///   - placeGeocoder: Service that provides `Place` coordinates
    ///   - registrationService: Service that manages register form
    init(
        gameId: Int,
        gameInfoLoader: GameInfoLoader,
        placeGeocoder: PlaceGeocoderProtocol,
        registrationService: RegistrationServiceProtocol
    ) {
        var gameInfo = GameInfo()
        gameInfo.id = gameId
        self.gameInfo = gameInfo
        self.gameInfoLoader = gameInfoLoader
        self.placeGeocoder = placeGeocoder
        self.registrationService = registrationService
    }

    // MARK: - GamePageInteractorProtocol

    func loadGame(complpetion: @escaping (Error?) -> Void) {
        gameInfoLoader.load(gameId: gameInfo.id) { [weak self] result in
            guard let self else { return }
            var error: Error?
            switch result {
            case .success(let game):
                self.registrationService.loadData()
                self.gameInfo = game
            case .failure(let failure):
                error = failure
            }
            complpetion(error)
        }
    }

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

    // MARK: - GamePageDescriptionProvider

    func getDescription() -> String? {
        gameInfo.optionalDescription
    }

//    // MARK: - GamePageRegisterFormProvider
//
//    func getRegisterForm() -> RegisterForm {
//        registrationService.getRegisterForm()
//    }
}
