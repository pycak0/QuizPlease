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

    /// Initialize `PlaceGeocoder`
    /// - Parameters:
    ///   - geocoder: Object that geocodes address string to coordinates
    init(geocoder: Geocoder) {
        self.geocoder = geocoder
    }

    // MARK: - PlaceGeocoderProtocol

    func getCoordinate(_ place: Place, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        if !place.isZeroCoordinate && CLLocationCoordinate2DIsValid(place.coordinate) {
            print("[\(Self.self)] Provided coordinates are valid. Returning them in completion")
            completion(place.coordinate)
            return
        }
        var searchAttempts = [
            SearchAttempt(place: place, query: place.fullAddress),
            SearchAttempt(place: place, query: place.cityName),
            SearchAttempt(place: place, query: place.cityNameLatin)
        ]
        evaluate(attempts: searchAttempts) { targetCoordinate in
            let finalCoordinate = CLLocationCoordinate2DIsValid(targetCoordinate) ? targetCoordinate : .zero
            completion(finalCoordinate)
        }
    }

    // MARK: - Private Methods

    private func evaluate(attempts: [SearchAttempt], completion: @escaping (CLLocationCoordinate2D) -> Void) {
        var searchAttempts = attempts
        guard !searchAttempts.isEmpty else {
            print("❌ [\(Self.self)] Empty attempts list passed. Returning the zero value in completion")
            completion(.zero)
            return
        }
        let attemptsLeft = searchAttempts.count
        let attempt = searchAttempts.removeFirst()
        print("[\(Self.self)] Trying to geocode location for place (attempts left \(attemptsLeft)): \(attempt.place)...")

        geocoder.geocodeAddress(attempt.query) { [weak self, searchAttempts] coordinate in
            guard let self else { return }

            if let coordinate {
                let logMessage = "[\(Self.self)] Successfully geocoded location " +
                "for place \(attempt.place), coordinate: \(coordinate)"
                print(logMessage)
                completion(coordinate)
                return
            }

            if searchAttempts.isEmpty {
                print("[\(Self.self)] Failed to geocode Place coordinate. Returning the input value in completion")
                completion(attempt.place.coordinate)
            } else {
                self.evaluate(attempts: searchAttempts, completion: completion)
            }
        }
    }
}
