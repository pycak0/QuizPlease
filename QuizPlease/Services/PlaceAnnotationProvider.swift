//
//  PlaceAnnotationProvider.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Service that provides `Place` annotation with coordinates
protocol PlaceAnnotationProviderProtocol {

    /// Method tries to geocode location based on the place properties such as address or city name
    /// - Parameter completion: closure that contains a `Place` instance
    func getPlace(initialPlace: Place, completion: @escaping (Place) -> Void)
}

/// Service that provides `Place` annotation with coordinates
final class PlaceAnnotationProvider: PlaceAnnotationProviderProtocol {

    private struct SearchAttempt {
        let place: Place
        let query: String
    }

    // MARK: - Private Properties

    private var searchAttempts = [SearchAttempt]()
    private var attemptsUsed = 0

    // MARK: - PlaceAnnotationProviderProtocol

    func getPlace(initialPlace place: Place, completion: @escaping (Place) -> Void) {
        if !place.isZeroCoordinate {
            completion(place)
            return
        }
        attemptsUsed = 0
        searchAttempts = [
            SearchAttempt(place: place, query: place.fullAddress),
            SearchAttempt(place: place, query: place.cityName),
            SearchAttempt(place: place, query: place.cityNameLatin)
        ]
        evaluateAttempts(completion: completion)
    }

    // MARK: - Private Methods

    private func evaluateAttempts(completion: @escaping (Place) -> Void) {
        guard !searchAttempts.isEmpty else { return }
        let attempt = searchAttempts.removeFirst()
        attemptsUsed += 1
        print("[\(Self.self)] Trying to geocode location for place (attempt #\(attemptsUsed)): \(attempt.place)...")
        MapService.getLocation(from: attempt.query) { [weak self] location in
            guard let self = self else { return }
            guard let location = location else {
                if self.searchAttempts.isEmpty {
                    completion(attempt.place)
                } else {
                    self.evaluateAttempts(completion: completion)
                }
                return
            }
            let logMessage = "[\(Self.self)] Successfully geocoded location " +
            "for place \(attempt.place) from attempt #\(self.attemptsUsed)"
            print(logMessage)

            attempt.place.coordinate = location.coordinate
            completion(attempt.place)
        }
    }
}
