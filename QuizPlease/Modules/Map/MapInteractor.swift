//
//  MapInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation
import CoreLocation

/// Object that geocodes address string to coordinates
protocol Geocoder {
    
    /// Geocode given address string to coordinates on map in form of '`CLLocationCoordinate2D`'
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void)
}

/// A geocoder that uses Core Location's `CLGeocoder`
class DefaultGeocoder: Geocoder {
    
    let geocoder: CLGeocoder
    
    init(
        geocoder: CLGeocoder = .init()
    ) {
        self.geocoder = geocoder
    }
    
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print(error)
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
}

/// Map Interactor input protocol
protocol MapInteractorInput {
    
    func getPlaceAnnotation(completion: @escaping (Place?) -> Void)
        
    func requestLocationAuthorizationStatus(completion: @escaping (Bool) -> Void)
}

private struct SearchAttempt {
    let query: String
}

final class MapInteractor: MapInteractorInput {
    
    private let place: Place
    private let geocoder: Geocoder
    private let locationAuthService: UserLocationAuthorizationService
    
    private var searchAttempts = [SearchAttempt]()
    private var attemptsUsed = 0
    
    init(
        place: Place,
        geocoder: Geocoder,
        locationAuthService: UserLocationAuthorizationService
    ) {
        self.place = place
        self.geocoder = geocoder
        self.locationAuthService = locationAuthService
    }
    
    func getPlaceAnnotation(completion: @escaping (Place?) -> Void) {
        if !place.isZeroCoordinate {
            completion(place)
            return
        }
        attemptsUsed = 0
        searchAttempts = [
            SearchAttempt(query: place.fullAddress),
            SearchAttempt(query: place.cityName),
            SearchAttempt(query: place.cityNameLatin)
        ]
        evaluateAttempts(completion: completion)
    }
    
    private func evaluateAttempts(completion: @escaping (Place?) -> Void) {
        guard !searchAttempts.isEmpty else {
            return
        }
        let attempt = searchAttempts.removeFirst()
        attemptsUsed += 1
        print("[\(Self.self)] Trying to geocode location for place (attempt #\(attemptsUsed)): \(place)...")
        
        geocoder.geocodeAddress(attempt.query) { [weak self] coordinate in
            guard let self = self else { return }
            if let coordinate = coordinate {
                print("[\(Self.self)] Successfully geocoded location for place \(self.place) from attempt #\(self.attemptsUsed)")
                
                self.place.coordinate = coordinate
                completion(self.place)
            } else {
                self.evaluateAttempts(completion: completion)
            }
        }
    }
    
    func requestLocationAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        locationAuthService.requestAuthorization(completion: completion)
    }
}
