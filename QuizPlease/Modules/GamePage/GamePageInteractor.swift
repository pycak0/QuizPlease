//
//  GamePageInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage interactor protocol
protocol GamePageInteractorProtocol: AnyObject,
                                     GameStatusProvider,
                                     GamePageAnnotationProvider,
                                     GamePageInfoProvider,
                                     GamePageDescriptionProvider,
                                     GamePageSubmitButtonTitleProvider {

    /// Load game info
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

    // MARK: - Private Properties

    private var gameInfo: GameInfo
    private var parsedHtmlDescription: NSAttributedString?
    private let gameInfoLoader: GameInfoLoader
    private let placeGeocoder: PlaceGeocoderProtocol
    private let registrationService: RegistrationServiceProtocol

    // MARK: - Lifecycle

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

    // MARK: - Private Methods

    private func parseHtmlDescription(text: String?, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.parsedHtmlDescription = text?.htmlFormatted()?.trimmingWhitespacesAndNewlines()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    // MARK: - GamePageInteractorProtocol

    func loadGame(complpetion: @escaping (Error?) -> Void) {
        gameInfoLoader.load(gameId: gameInfo.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let game):
                self.registrationService.loadData()
                self.gameInfo = game
                self.parseHtmlDescription(text: game.optionalDescription) {
                    complpetion(nil)
                }
                return
            case .failure(let error):
                complpetion(error)
            }
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

    func getDescription() -> NSAttributedString? {
        parsedHtmlDescription ?? gameInfo.optionalDescription.map { NSAttributedString(string: $0) }
    }

    // MARK: - SpecialConditionsProvider

    var canAddSpecialCondition: Bool {
        registrationService.canAddSpecialCondition
    }

    func addSpecialCondition() -> SpecialCondition? {
        registrationService.addSpecialCondition()
    }

//    // MARK: - GamePageRegisterFormProvider
//
//    func getRegisterForm() -> RegisterForm {
//        registrationService.getRegisterForm()
//    }

    // MARK: - GamePageSubmitButtonTitleProvider

    func getSubmitButtonTitle() -> String {
        let registerForm = registrationService.getRegisterForm()
        return registerForm.paymentType == .online ? "Оплатить игру" : "Записаться на игру"
    }
}
