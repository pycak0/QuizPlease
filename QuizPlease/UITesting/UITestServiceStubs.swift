//
//  UITestServiceStubs.swift
//  QuizPlease
//
//  Created by Codex on 07.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import CoreLocation

final class UITestGameInfoLoader: GameInfoLoader {

    private let game: GameInfo

    init(game: GameInfo) {
        self.game = game
    }

    func load(gameId: String, completion: @escaping (Result<GameInfo, Error>) -> Void) {
        completion(.success(game))
    }

    func getCachedGame(gameId: String) -> GameInfo? {
        game
    }
}

final class UITestPlaceGeocoder: PlaceGeocoderProtocol {

    func getCoordinate(_ place: Place, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        completion(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
}

final class UITestAnalyticsService: AnalyticsService {

    func sendEvent(_ event: AnalyticsEvent) { }
}

#endif
