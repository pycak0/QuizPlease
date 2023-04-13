//
//  MapInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation
import CoreLocation

/// Map Interactor input protocol
protocol MapInteractorInput {

    func getPlaceAnnotation(completion: @escaping (Place) -> Void)

    func requestLocationAuthorizationStatus(completion: @escaping (Bool) -> Void)
}

final class MapInteractor: MapInteractorInput {

    // MARK: - Private Properties

    private let place: Place
    private let placeGeocoder: PlaceGeocoderProtocol
    private let locationAuthService: UserLocationAuthorizationService

    // MARK: - Lifecycle

    init(
        place: Place,
        placeGeocoder: PlaceGeocoderProtocol,
        locationAuthService: UserLocationAuthorizationService
    ) {
        self.place = place
        self.placeGeocoder = placeGeocoder
        self.locationAuthService = locationAuthService
    }

    // MARK: - MapInteractorInput

    func getPlaceAnnotation(completion: @escaping (Place) -> Void) {
        placeGeocoder.getCoordinate(place) { [weak place] coordinate in
            guard let place else { return }
            place.coordinate = coordinate
            completion(place)
        }
    }

    func requestLocationAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        locationAuthService.requestAuthorization(completion: completion)
    }
}
