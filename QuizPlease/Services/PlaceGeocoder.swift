//
//  PlaceGeocoder.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation
import CoreLocation

/// Protocol of Service that provides `Place` coordinates
protocol PlaceGeocoderProtocol {

    /// Method tries to geocode coordinates based on the place properties such as address or city name
    /// - Parameter completion: closure that contains a `Place` instance
    func getCoordinate(_ place: Place, completion: @escaping (CLLocationCoordinate2D) -> Void)
}

/// Service that provides `Place` coordinates
final class PlaceGeocoder: PlaceGeocoderProtocol {

    private struct SearchAttempt {
        let place: Place
        let query: String
    }

    // MARK: - Private Properties

    private let geocoder: Geocoder

    private var searchAttempts = [SearchAttempt]()
    private var attemptsUsed = 0

    /// Initialize `PlaceGeocoder`
    /// - Parameters:
    ///   - geocoder: Object that geocodes address string to coordinates
    init(geocoder: Geocoder) {
        self.geocoder = geocoder
    }

    // MARK: - PlaceGeocoderProtocol

    func getCoordinate(_ place: Place, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        if !place.isZeroCoordinate {
            completion(place.coordinate)
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

    private func evaluateAttempts(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        guard !searchAttempts.isEmpty else { return }
        let attempt = searchAttempts.removeFirst()
        attemptsUsed += 1
        print("[\(Self.self)] Trying to geocode location for place (attempt #\(attemptsUsed)): \(attempt.place)...")

        geocoder.geocodeAddress(attempt.query) { [weak self] coordinate in
            guard let self = self else { return }

            if let coordinate {
                let logMessage = "[\(Self.self)] Successfully geocoded location " +
                "for place \(attempt.place) from attempt #\(self.attemptsUsed)"
                print(logMessage)
                completion(coordinate)
                return
            }

            if self.searchAttempts.isEmpty {
                print("[\(Self.self)] Failed to geocode Place coordinate. Returning the input value in completion")
                completion(attempt.place.coordinate)
            } else {
                self.evaluateAttempts(completion: completion)
            }
        }
    }
}
